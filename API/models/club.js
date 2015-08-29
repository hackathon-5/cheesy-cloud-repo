var mongoose = require('mongoose');

mongoose.connect('mongodb://localhost:27017/miniFridge');

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