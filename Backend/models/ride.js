const mongoose = require('mongoose');

const rideSchema = new mongoose.Schema({
    startLocation: {
        type: [Number],
        required: true
    },
    endLocation: {
        type: [Number],
        required: true
    },
    date: {
        type: Date,
        required: true
    },
    time: { 
        type: String,
        required: true
    },
    availableSeats: {
        type: Number,
        required: true
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    status: {
        type: String,
        enum: ['available', 'in_progress', 'completed', 'cancelled'],
        default: 'available'
    },
    passengers: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
     }],
     
});

const Ride = mongoose.model('Ride', rideSchema);

module.exports = Ride;
