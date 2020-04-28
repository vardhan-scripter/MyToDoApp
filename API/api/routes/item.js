const express = require("express");
const passport = require("passport");
const Item = require("../../models/Item");

const router = express.Router();

//@type  POST
//@route  /addItem
//@desc  Add new item to items
//@access PRIVATE

router.post('/addItem',passport.authenticate("jwt", {session: false}),(req,res) => {
    const newItem = Item({
        name: req.body.name,
        description: req.body.description,
        email: req.user.email,
    })
    newItem
        .save()
        .then(item => {
            if(!item) {
                res.json({success: false, Errormessage: "Error in inserting item"})
            }else{
                res.json({success: true})
            }
        })
        .catch(err => {
            res.json({success: false, Errormessage: "Internal server error"})
        })
})

//@type  POST
//@route  /addDocument
//@desc  Add new document to items
//@access PRIVATE

router.post('/addDocument',passport.authenticate("jwt", {session: false}),(req,res) => {
    Item.insertMany(req.body.items)
        .then(success => {
            if(!success) {
                res.json({success: false, Errormessage: "Error in inserting document"})
            }else{
                res.json({success: true})
            }
        })
        .catch(err => {
            res.json({success: false, Errormessage: err})
        })
})

//@type  GET
//@route  /getItem/:id
//@desc  get item by id
//@access PRIVATE

router.get('/getItem/:id',passport.authenticate("jwt", {session: false}),(req,res) => {
    Item.find({_id:req.params.id,email:req.user.email})
        .then(item => {
            if(!item) {
                res.json({success: false, Errormessage: "No data found"})
            }else{
                res.json({success: true, item: item})
            }
        })
        .catch(err => {
            res.json({success: false, Errormessage: "Internal server error"})
        })
})

//@type  GET
//@route  /getItems
//@desc  get all items
//@access PRIVATE

router.get('/getItems',passport.authenticate("jwt", {session: false}),(req,res) => {
    Item.find({email:req.user.email})
        .then(items => {
            if(!items) {
                res.json({success: false, Errormessage: "No data found"})
            }else{
                res.json({success: true, items: items})
            }
        })
        .catch(err => {
            res.json({success: false, Errormessage: "Internal server error"})
        })
})

//@type  POST
//@route  /updateItem
//@desc  update item by id
//@access PRIVATE

router.post('/updateItem',passport.authenticate("jwt", {session: false}),(req,res) => {
    Item.findByIdAndUpdate(
        {_id: req.body._id},
        {
            name: req.body.name,
            description: req.body.description
        }
    ).then(success => {
        if(!success) {
            res.json({success: false, Errormessage: "Error in updating item"})
        }else{
            res.json({success: true})
        } 
    }).catch(err => {
        res.json({success: false, Errormessage: "Internal server error"})
    })
})

//@type  POST
//@route  /toggleItem
//@desc  update item by id
//@access PRIVATE

router.post('/toggleItem',passport.authenticate("jwt", {session: false}),(req,res) => {
    Item.findById(req.body._id)
        .then(item => {
            const toggle = item.done ? false:true;
            Item.findByIdAndUpdate(
                {_id: req.body._id},
                {
                    done: toggle
                }
            ).then(success => {
                if(!success) {
                    res.json({success: false, Errormessage: "Error in updating item"})
                }else{
                    res.json({success: true})
                } 
            }).catch(err => {
                res.json({success: false, Errormessage: "Internal server error"})
            })
        })
        .catch(err => {
            res.json({success: false, Errormessage: "Internal server error"})
        })
})

//@type  DELETE
//@route  /deleteItem
//@desc  delete item by id
//@access PRIVATE

router.delete('/deleteItem',passport.authenticate("jwt", {session: false}),(req,res) => {
    Item.findByIdAndDelete(req.body._id)
        .then(success => {
            if(!success) {
                res.json({success: false, Errormessage: "Error in deleting item"})
            }else{
                res.json({success: true})
            } 
        })
        .catch(err => {
            res.json({success: false, Errormessage: "Internal server error"})
        })
})

module.exports = router;