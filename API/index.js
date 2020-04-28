const express = require("express");

const app = express();

const mongoose = require("mongoose");
const bodyparser = require("body-parser");
const db = require("./setup/config").dbConnetction;
const auth = require("./api/routes/auth");
const item = require("./api/routes/item");
const passport = require("passport");


// passport middleware
app.use(passport.initialize());

app.use(bodyparser.urlencoded({extended: false}));
app.use(bodyparser.json());

app.use((req, res, next) => {
    res.header("Access-Control-Allow-Origin", "*"); // update to match the domain you will make the request from
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    res.header('Access-Control-Allow-Methods', 'PUT, POST, GET, DELETE, OPTIONS');
    next();
  });

mongoose.set('useNewUrlParser', true);
mongoose.set('useUnifiedTopology', true);
mongoose.set('useFindAndModify', false);

mongoose
    .connect(db)
    .then(() => {
        console.log("Database connetcted successfully");
    })
    .catch(err => console.log(err));

//config for jwt strategy
require("./strategies/jsonwtStrategy")(passport);

app.use('/auth',auth);
app.use('/item',item);

//@type  GET
//@route  *
//@desc  All the alternative routes handler
//@access PRIVATE

app.get('*',(req,res) => {
    res.json({greetings: "Welcome to MyToDoApplication"});
});

const port = process.env.PORT || 3000;

app.listen(port, () => console.log(`server running on port ${port}`));