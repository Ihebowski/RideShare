const Ride = require('../models/ride');
const User = require('../models/user');
const Notification = require('../models/Notification');
const turf = require('@turf/turf');

// Create a new ride
exports.createride = async (req, res) => {
    try {
        const { startLocation, endLocation, date, time, availableSeats, user } = req.body;
        
        if (!Array.isArray(startLocation) || startLocation.length !== 2) {
            return res.status(400).json({ message: "Invalid start location format" });
        }

        const newRide = new Ride({
            startLocation,
            endLocation,
            date,
            time,
            availableSeats,
            user,
            passengers: [] 
        });
        
        const savedRide = await newRide.save();
        res.status(201).json({ status: 'success', result: savedRide, message: "Ride added successfully" });
        
    } catch (error) {
        console.error(error); 
        res.status(500).json({ status: 'error', message: 'Error creating ride', error: error.message });
    }
};

exports.fetchDrivers = async (req, res) => {
    try {
        const { startLocation, endLocation } = req.body;

        const startPoint = turf.point(startLocation);
        const endPoint = turf.point(endLocation);

        const rides = await Ride.find({ status: 'available' }).populate('user', 'name role');

        const filteredRides = rides.filter(ride => {
            const rideStartPoint = turf.point(ride.startLocation);
            const rideEndPoint = turf.point(ride.endLocation);
            const startDistance = turf.distance(startPoint, rideStartPoint, { units: 'kilometers' });
            const endDistance = turf.distance(endPoint, rideEndPoint, { units: 'kilometers' });
            const distanceThreshold = 5;

            return startDistance <= distanceThreshold && endDistance <= distanceThreshold;
        });

        res.status(200).json({ status: 'success', rides: filteredRides });

    } catch (error) {
        console.error("Error details:", error);
        res.status(500).json({ status: 'error', message: 'Error fetching rides', error: error.message });
    }
};

exports.updateRide = async (req, res) => {
    try {
        const id = req.params.id;

        const updateRide = {
            startLocation: req.body.startLocation,
            endLocation: req.body.endLocation,
            date: req.body.date,
            time: req.body.time,
            availableSeats: req.body.availableSeats,
            status: req.body.status 
        };

        const updatedRide = await Ride.findByIdAndUpdate(id, updateRide, { new: true });

        if (!updatedRide) {
            return res.status(404).json({ status: 'error', message: 'Ride not found' });
        }

        res.status(200).json({ status: 'success', result: updatedRide, message: "Ride updated successfully" });

    } catch (error) {
        console.error(error);
        res.status(500).json({ status: 'error', message: 'Failed to update ride', error: error.message });
    }
};

exports.deleteRide = async (req, res) => {
    try {
        // Find the ride to be deleted and populate passengers and driver details
        const ride = await Ride.findById(req.params.id).populate('passengers user', 'name email');

        if (!ride) {
            return res.status(404).json({ status: 'error', message: 'Ride not found' });
        }

        // Notify all passengers that the ride is being cancelled
        const passengerNotifications = ride.passengers.map(passenger => {
            return new Notification({
                rideId: ride._id,
                userId: passenger._id,
                driverId: ride.user._id,  // Assuming 'user' is the driver
                message: `The ride from ${ride.startLocation} to ${ride.endLocation} has been cancelled by the driver.`,
                status: 'cancelled'
            });
        });

        // Save all passenger notifications
        await Notification.insertMany(passengerNotifications);

        // Delete all existing notifications related to the ride except those with 'cancelled' status
        await Notification.deleteMany({ rideId: ride._id, status: { $ne: 'cancelled' } });

        // Finally, delete the ride
        await Ride.findByIdAndDelete(req.params.id);

        res.status(200).json({ status: 'success', message: 'Ride and related notifications deleted successfully, and passengers have been notified.' });

    } catch (error) {
        console.error(error);
        res.status(500).json({ status: 'error', message: 'Error deleting ride', error: error.message });
    }
};




exports.joinRide = async (req, res) => {
    

    console.log('Request Body:', req.body);

    const { rideId, userId } = req.body;
    console.log('Ride ID:', rideId);
    console.log('Passenger ID:', userId);
    try {
       
        const ride = await Ride.findById(rideId);
        if (!ride) return res.status(404).send('Ride not found');

        if (ride.availableSeats <= 0) {
            return res.status(400).send('No available seats for this ride');
        }

        const passenger = await User.findById(userId);
        if (!passenger) return res.status(404).send('Passenger not found');

        const existingNotification = await Notification.findOne({
            rideId: ride._id,
            userId
        });

        if (existingNotification) {
            return res.status(400).send('Notification already sent for this ride');
        }

        // Create a notification for the driver
        const notification = new Notification({
            rideId: ride._id,
            userId,
            driverId: ride.user, // Assuming 'user' is the driver in the Ride model
            message: `Passenger ${passenger.name} has requested to join the ride.`,
            status: 'pending'
        });

        await notification.save();

       

        res.status(200).send('Notification sent to the driver.');
    } catch (error) {
        console.error(error);
        res.status(500).send('Error sending notification');
    }
};

exports.respondToRequest = async (req, res) => {
    const { notificationId, driverId, response } = req.body;

    try {
        const notification = await Notification.findById(notificationId);
        if (!notification) return res.status(404).send('Notification not found');

        const ride = await Ride.findById(notification.rideId);
        if (!ride) return res.status(404).send('Ride not found');

        const driver = await User.findById(driverId);
        if (!driver) return res.status(404).send('Driver not found');

        const passenger = await User.findById(notification.userId);
        if (!passenger) return res.status(404).send('Passenger not found');

        if (response === 'accept') {
            // Check if the passenger is already in the ride
            if (ride.passengers.includes(passenger._id)) {
                return res.status(400).send('Passenger is already in the ride.');
            }

            // Add passenger to the ride's passengers list
            ride.passengers.push(passenger._id);

            // Decrease available seats
            ride.availableSeats -= 1;
            await ride.save();

            // Update the notification status to accepted
            notification.status = 'accepted';
            await notification.save();

            // Notify the passenger that the driver accepted the request
            const passengerNotification = new Notification({
                rideId: ride._id,
                userId: passenger._id,
                driverId: driver._id,
                message: `Driver ${driver.name} has accepted your request. Contact them at ${driver.phone} or ${driver.email}.`,
                status: 'accepted'
            });

            await passengerNotification.save();

            // If no available seats are left, update ride status to 'in_progress'
            if (ride.availableSeats === 0) {
                ride.status = 'in_progress';
                await ride.save();
            }

            res.status(200).send('Ride accepted, passenger added to the ride, and seats updated.');
        } else if (response === 'decline') {
            // Update notification status to declined
            notification.status = 'declined';
            await notification.save();

            // Notify the passenger that the request was declined
            const passengerNotification = new Notification({
                rideId: ride._id,
                userId: passenger._id,
                driverId: driver._id,
                message: `Driver ${driver.name} has declined your request.`,
                status: 'declined'
            });

            await passengerNotification.save();

            res.status(200).send('Ride request declined, passenger notified.');
        } else {
            return res.status(400).send('Invalid response');
        }
    } catch (error) {
        console.error(error);
        res.status(500).send('Error processing response');
    }
};

exports.leaveRide = async (req, res) => {
    try {
        const { rideId, userId } = req.body;

        const ride = await Ride.findById(rideId).populate('user'); // Populate to get the driver info

        if (!ride) {
            return res.status(404).json({ status: 'error', message: 'Ride not found' });
        }

        const passengerIndex = ride.passengers.indexOf(userId);
        if (passengerIndex === -1) {
            return res.status(400).json({ status: 'error', message: 'User not a passenger in this ride' });
        }

        // Remove passenger from the passengers array
        ride.passengers.splice(passengerIndex, 1);

        // Increment available seats
        ride.availableSeats += 1;

        await ride.save();

        // Find the passenger who left the ride
        const passenger = await User.findById(userId);
        if (!passenger) {
            return res.status(404).json({ status: 'error', message: 'Passenger not found' });
        }

        // Send notification to the driver
        const notification = new Notification({
            rideId: ride._id,
            userId: ride.user._id, // Driver ID
            driverId: ride.user._id, // Driver is the one receiving the notification
            message: `Passenger ${passenger.name} has left the ride.`,
            status: 'left'
        });

        await notification.save();

        res.status(200).json({ status: 'success', message: 'Left the ride successfully and driver notified.', ride });

    } catch (error) {
        console.error(error);
        res.status(500).json({ status: 'error', message: 'Error leaving the ride', error: error.message });
    }
};

