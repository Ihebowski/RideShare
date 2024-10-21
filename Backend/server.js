// Import required modules
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

// Import routes
const userRoutes = require('./routes/userRoutes');
const rideRoutes = require('./routes/rideRoutes');

// Import models
const User = require('./models/user');           // Assuming User model exists
const Ride = require('./models/ride');           // Assuming Ride model exists
const Notification = require('./models/Notification'); // Assuming Notification model exists

// Initialize express app
const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());

// MongoDB Connection
mongoose.connect('mongodb://localhost:27017/rideshare', {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
.then(() => {
    console.log('Connected to MongoDB');
})
.catch((error) => {
    console.log('MongoDB connection error:', error);
});

// Route: Passenger requests to join a ride
app.post('/api/rides/join_ride', async (req, res) => {
    const { rideId, passengerId } = req.body;

    try {
        const ride = await Ride.findById(rideId);
        if (!ride) return res.status(404).send('Ride not found');

        // Check if the ride has available seats
        if (ride.availableSeats <= 0) {
            return res.status(400).send('No available seats for this ride');
        }

        const passenger = await User.findById(passengerId);
        if (!passenger) return res.status(404).send('Passenger not found');

        // Check if a notification has already been sent
        const existingNotification = await Notification.findOne({
            rideId: ride._id,
            passengerId
        });

        if (existingNotification) {
            return res.status(400).send('Notification already sent for this ride');
        }

        // Create a notification for the driver
        const notification = new Notification({
            rideId: ride._id,
            passengerId,
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
});

// Route: Driver accepts or declines the ride request
app.post('/api/rides/response', async (req, res) => {
    const { notificationId, driverId, response } = req.body; // response: 'accept' or 'decline'

    try {
        const notification = await Notification.findById(notificationId);
        if (!notification) return res.status(404).send('Notification not found');

        const ride = await Ride.findById(notification.rideId);
        if (!ride) return res.status(404).send('Ride not found');

        const driver = await User.findById(driverId);
        if (!driver) return res.status(404).send('Driver not found');

        const passenger = await User.findById(notification.passengerId);
        if (!passenger) return res.status(404).send('Passenger not found');

        if (response === 'accept') {
            // Update ride's available seats
            ride.availableSeats -= 1;
            await ride.save();

            // Update notification status
            notification.status = 'accepted';
            await notification.save();

            // Send notification to the passenger with the driver's details
            const passengerNotification = new Notification({
                rideId: ride._id,
                passengerId: passenger._id,
                driverId: driver._id,
                message: `Driver ${driver.name} has accepted your request. Contact them at ${driver.phone} or ${driver.email}.`,
                status: 'accepted'
            });

            await passengerNotification.save();

            // If seats are 0, update ride status to 'full'
            if (ride.availableSeats === 0) {
                ride.status = 'in_progress';
                await ride.save();
            }

            res.status(200).send('Ride accepted, passenger notified, and seats updated.');
        } else if (response === 'decline') {
            // Update notification status to declined
            notification.status = 'declined';
            await notification.save();

            // Send notification to the passenger
            const passengerNotification = new Notification({
                rideId: ride._id,
                passengerId: passenger._id,
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
});

// API Routes
app.use('/api/users', userRoutes);
app.use('/api/rides', rideRoutes);

// Start the server
const PORT = process.env.PORT || 5000; // Use environment variable for port
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
