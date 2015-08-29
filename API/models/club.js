var mongoose = require('mongoose');

var ClubSchema = new mongoose.Schema({
    name: String,
    ownerId: Number,
    registered:[],
    updated_at: { type: Date, default: Date.now }
});

var Club = mongoose.model('Club', ClubSchema);

module.exports = {
    Club: Club
};