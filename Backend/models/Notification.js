const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
    rideId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Ride',
        required: true
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    driverId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true
    },
    message: {
        type: String,
        required: true
    },
    status: {
        type: String,
        enum: ['pending', 'accepted', 'declined','left','cancelled'],
        default: 'pending'
    },
    type: {
        type: String,
        enum: ['request', 'response'],
        default: ''
    }
}, { timestamps: true });

notificationSchema.statics.findByUser = function(userId) {
    return this.find({ $or: [{ passengerId: userId }, { driverId: userId }] });
};

module.exports = mongoose.model('Notification', notificationSchema);
