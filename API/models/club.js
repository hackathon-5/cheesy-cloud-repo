var mongoose = require('mongoose');

var ClubSchema = new mongoose.Schema({
    name: String,
    tagline: String,
    profilePicUrl: String,
    description: String,
    ownerId: Number,
    members:[],
    updated_at: { type: Date, default: Date.now }
});

var Club = mongoose.model('Club', ClubSchema);

module.exports = {
    Club: Club
};