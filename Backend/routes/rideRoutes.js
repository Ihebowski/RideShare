const express = require('express');
const router = express.Router();
const ridecontroller = require("../controllers/rideController")

router.post('/create', ridecontroller.createride);      
router.put('/update/:id', ridecontroller.updateRide)
router.delete('/delete/:id', ridecontroller.deleteRide);
router.post('/fetch-drivers', ridecontroller.fetchDrivers);


router.post('/join', ridecontroller.joinRide);
router.post('/reponse', ridecontroller.respondToRequest);
router.get('/getallnotifdriver/:driverId',ridecontroller.getNotificationsForDriver)
router.get('/getallnotifuser/:userId',ridecontroller.getUserNotifications)
router.post('/leave', ridecontroller.leaveRide);

module.exports=router