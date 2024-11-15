// Import required modules
const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const cron = require('node-cron');
const userRoutes = require('./routes/userRoutes');
const rideRoutes = require('./routes/rideRoutes');

// Import dotenv to load environment variables from .env file
require('dotenv').config();

// Import models
const User = require('./models/user');           // Assuming User model exists
const Ride = require('./models/ride');           // Assuming Ride model exists
const Notification = require('./models/Notification'); // Assuming Notification model exists

// Initialize express app
const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());

// MongoDB Atlas connection string
mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
.then(() => {
    console.log('Connected to MongoDB Atlas');
})
.catch((error) => {
    console.log('MongoDB Atlas connection error:', error);
});

cron.schedule('0 0 * * *', async () => {
    try {
        
        const today = new Date().toISOString().split('T')[0];

        // Find and delete rides with today's date
        const deletedRides = await Ride.deleteMany({
            date: today
        });

        console.log(`Deleted ${deletedRides.deletedCount} ride(s) scheduled for ${today}`);
    } catch (error) {
        console.error('Error deleting scheduled rides:', error);
    }
});

app.use('/api/users', userRoutes);
app.use('/api/rides', rideRoutes);

// Start the server
const PORT = process.env.PORT || 9001; // Use environment variable for port
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
