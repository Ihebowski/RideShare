const mongoose = require("mongoose")

const userSchema = new mongoose.Schema({
    name:{
        type:String,
        require:true
    },
    email:{
        type: String,
        required: true,
        unique: true,
        trim: true,
        lowercase: true
    },
    password:{
        type:String,
        required:true
    },
    phone:{
        type:String,
        required:true
    },
    role:{
        type:String,
        enum:['driver','passenger'],
    }

})
const User = mongoose.model('User', userSchema);

module.exports = User;