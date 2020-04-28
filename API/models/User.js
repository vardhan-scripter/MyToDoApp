const mongoose = require("mongoose");
const Schema = mongoose.Schema;

const UserSchema = new Schema({
    email: {
        type: String,
        required: true,
    },
    password: {
        type: String,
        required: true,
    },
    name: {
        type: String,
        required: true,
    },
    profilepic: {
        type: String,
        default: "./user.png",
    },
    date: {
        type: Date,
        default: Date.now(),
    },
})

module.exports = User = mongoose.model('user',UserSchema);