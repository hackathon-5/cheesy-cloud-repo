var express = require('express');
var Club = require("../models/club").Club;
var router = express.Router();


/* GET home page. */
router.get('/', function(req, res, next) {
    res.render('index', { title: 'Express' });
});


/* GET Clubs. */
router.get('/club/list', function(req, res) {
    res.setHeader('Content-Type', 'application/json');
    Club.find(function(err, clubs){
        res.send(JSON.stringify(clubs));
    });
});
/* GET Club by id */
router.get('/club/:id', function(req, res) {
    var _id = req.params.id;

    res.setHeader('Content-Type', 'application/json');
    Club.findById(_id,function(err, club){
        res.send(JSON.stringify(club));
    });
});
/* GET Club by owner */
router.get('/clubsByOwner/:id', function(req, res) {
    var ownerId = req.params.id;

    res.setHeader('Content-Type', 'application/json');
    Club.find({ownerId: ownerId},function(err, clubs){
        res.send(JSON.stringify(clubs));
    });
});
/* GET Clubs by member. */
router.get('/clubsByRegistered/:id', function(req, res) {

    var registeredId = req.params.id;
    if(registeredId){
        res.setHeader('Content-Type', 'application/json');
        Club.find({"members.id": registeredId.toString()},function(err, clubs){
            res.send(JSON.stringify(clubs));
        });
    }

});

/* POST Club save. */
router.post('/club/save', function(req, res) {
    var jsonClub = req.body;

    if(!jsonClub){
        res.send("send in an object dummy");
    }

    if(jsonClub._id){
        Club.findByIdAndUpdate(jsonClub._id,jsonClub,function(err, club){
            if (err) {
                res.send("There was a problem updating the information to the database: " + err);
            }else{
                res.setHeader('Content-Type', 'application/json');
                res.send(JSON.stringify(club));
            }
        });
    }else{
        res.setHeader('Content-Type', 'application/json');
        var club = new Club(jsonClub);
        club.save(function(err){
            if(err){
                res.send(JSON.stringify({success:false}))
            }else{
                res.send(JSON.stringify(club));
            }
        });

    }


});
/* GET Club delete. */
router.get('/club/delete/:id', function(req, res) {
    var _id = req.params.id;

    if(_id){
        Club.findByIdAndRemove(_id,function(err, club){
            res.setHeader('Content-Type', 'application/json');
            if(err){
                res.send(JSON.stringify({success:false}))
            }else{
                res.send(JSON.stringify({success:true}))
            }
        });
    }else{
        res.setHeader('Content-Type', 'application/json');
        var club = new Club(jsonClub);
        club.save(function(err){

        });

    }


});

/* POST register for club Club page. */
router.post('/club/register/:id', function(req, res) {
    var _id = req.params.id;
    var jsonUser = req.body;
    if(jsonUser && _id){
        Club.findByIdAndUpdate(_id, {$pull: {'members': {id:jsonUser.id}}}, {new: true}, function (err, club) {
            if (err) { return res.send(err) }

            Club.findByIdAndUpdate(_id,{$push: {members: jsonUser}},function(err, club){
                if (err) {
                    res.send("There was a problem updating the information to the database: " + err);
                }else{
                    res.setHeader('Content-Type', 'application/json');
                    res.send(JSON.stringify(club));
                }
            });
        });

    }
});
/* POST unregister for club Club page. */
router.post('/club/unregister/:id', function(req, res) {
    var _id = req.params.id;
    var jsonUser = req.body;
    if(jsonUser && _id){
        Club.findByIdAndUpdate(_id, {$pull: {'members': {id:jsonUser.id}}}, {new: true}, function (err, club) {
            res.setHeader('Content-Type', 'application/json');
            if(err){
                res.send(JSON.stringify({success:false}))
            }else{
                res.send(JSON.stringify({success:true}))
            }
        });

    }
});


module.exports = router;
