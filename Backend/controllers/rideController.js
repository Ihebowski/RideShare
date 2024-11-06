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
        const userId = req.body.id;  // Ensure this is passed in the request body

        const startPoint = turf.point(startLocation);
        const endPoint = turf.point(endLocation);

        // Fetch rides with status 'available' and where the user is not the current user
        const rides = await Ride.find({
            status: 'available',
            user: { $ne: userId } // Ensure the creator is not the same as the requesting user
        }).populate('user', 'name'); // Only populate the user's name, not role

        // Filter the rides based on the proximity to the provided start and end locations
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
        
        const ride = await Ride.findById(req.params.id).populate('passengers user', 'name email');

        if (!ride) {
            return res.status(404).json({ status: 'error', message: 'Ride not found' });
        }

        const passengerNotifications = ride.passengers.map(passenger => {
            return new Notification({
                rideId: ride._id,
                userId: passenger._id,
                driverId: ride.user._id,  
                message: `The ride from ${ride.startLocation} to ${ride.endLocation} has been cancelled by the driver.`,
                status: 'cancelled'
            });
        });

        // Save all passenger notifications
        await Notification.insertMany(passengerNotifications);

        // Delete all existing notifications related to the ride except those with 'cancelled' status
        await Notification.deleteMany({ rideId: ride._id, status: { $ne: 'cancelled' } });

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

        const notification = new Notification({
            rideId: ride._id,
            userId,
            driverId: ride.user, 
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
          
            if (ride.passengers.includes(passenger._id)) {
                return res.status(400).send('Passenger is already in the ride.');
            }

            ride.passengers.push(passenger._id);

           
            ride.availableSeats -= 1;
            await ride.save();

            notification.status = 'accepted';
            await notification.save();

            const passengerNotification = new Notification({
                rideId: ride._id,
                userId: passenger._id,
                driverId: driver._id,
                message: `Driver ${driver.name} has accepted your request. Contact them at ${driver.phone} or ${driver.email}.`,
                status: 'accepted'
            });

            await passengerNotification.save();

        
            if (ride.availableSeats === 0) {
                ride.status = 'in_progress';
                await ride.save();
            }

            res.status(200).send('Ride accepted, passenger added to the ride, and seats updated.');
        } else if (response === 'decline') {
      
            notification.status = 'declined';
            await notification.save();

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

exports.getUserNotifications = async (req, res) => {
    try {
        const { userId } = req.params;

        if (!userId) {
            return res.status(400).send('User ID is required');
        }

        const notifications = await Notification.find({ userId })
            .populate('rideId', 'startLocation endLocation date time') 
            .populate('driverId', 'name email phone'); 

        const filteredNotifications = notifications.filter(notification => 
            !notification.message.includes('has requested to join the ride')
        );

        res.status(200).json({
            status: 'success',
            notifications: filteredNotifications,
        });
    } catch (error) {
        console.error(error);
        res.status(500).send('Error fetching notifications');
    }
};


exports.getNotificationsForDriver = async (req, res) => {
    try {
        
        const driverId = req.params.driverId;

        if (!driverId) {
            return res.status(400).json({ status: 'error', message: 'Driver ID is required' });
        }

        const notifications = await Notification.find({ driverId })
            .populate('rideId', 'startLocation endLocation date time') 
            .populate('userId', 'name email'); 

            const filteredNotifications = notifications.filter(notification => 
                !notification.message.includes('has accepted your request') && 
                !notification.message.includes('has been cancelled by the driver')
            );
    
            res.status(200).json({
                status: 'success',
                notifications: filteredNotifications,
            });
    } catch (error) {
        console.error(error);
        res.status(500).json({ status: 'error', message: 'Error fetching notifications', error: error.message });
    }
};


exports.leaveRide = async (req, res) => {
    try {
        const { rideId, userId } = req.body;

        const ride = await Ride.findById(rideId).populate('user'); 

        if (!ride) {
            return res.status(404).json({ status: 'error', message: 'Ride not found' });
        }

        const passengerIndex = ride.passengers.indexOf(userId);
        if (passengerIndex === -1) {
            return res.status(400).json({ status: 'error', message: 'User not a passenger in this ride' });
        }

        ride.passengers.splice(passengerIndex, 1);

        ride.availableSeats += 1;

        await ride.save();

        const passenger = await User.findById(userId);
        if (!passenger) {
            return res.status(404).json({ status: 'error', message: 'Passenger not found' });
        }

        const notification = new Notification({
            rideId: ride._id,
            userId: ride.user._id, 
            driverId: ride.user._id, 
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

