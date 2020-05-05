const express = require("express");
const router = express.Router();
const bcrypt = require("bcryptjs");
const User = require("../../models/User");
const jsonwt = require("jsonwebtoken");
const key = require("../../setup/config");
const passport = require("passport");
const nodemailer = require('nodemailer');

var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: require("../../setup/config").auth,
});

//@type  POST
//@route  /register
//@desc  User Registration
//@access PUBLIC

router.post('/register',(req,res) => {
    User.findOne({email: req.body.email})
        .then(user => {
            if(user){
                return res
                .status(400)
                .json({
                    success: false,
                    message: "email is already exists"
                })
            }else{
                const newUser = new User({
                    email: req.body.email,
                    password: req.body.password,
                    name: req.body.name,
                })
                //Encrypt password using bcrypt
                bcrypt.genSalt(10,(err,salt) => {
                    bcrypt.hash(newUser.password, salt, (err,hash) => {
                        if(err) throw err;
                        newUser.password = hash;
                        newUser
                            .save()
                            .then(user => {
                                res.json({
                                    success: true,
                                    message: "Registration completed successfully"
                                })
                            })
                            .catch(err => {
                                res.json({success: false, message: "Internal server error"})
                            })
                    })
                })
            }
        })
        .catch(err => {
            res.json({success: false, message: "Internal server error"})
        })
});

//@type  POST
//@route  /login
//@desc  User Login
//@access PUBLIC

router.post('/login',(req,res) => {
    const email = req.body.email;
    const password= req.body.password;
    User.findOne({email: email})
        .then(user => {
            if(!user){
                return res
                    .status(404)
                    .json({
                        success: false,
                        message: "credentials mismatch"
                    })
            }
            bcrypt
                .compare(password,user.password)
                .then(isUser => {
                    if(isUser){
                        const payload = {
                            id: user.id,
                            email: user.email,
                            name: user.name,
                        }
                        jsonwt.sign(
                            payload,
                            key.secret,
                            {expiresIn: 36000},
                            (err,token) => {
                                res.json({
                                    success: true,
                                    message: "You login successfully",
                                    token: "Bearer " + token
                                });
                            })
                    }else{
                        return res
                            .status(404)
                            .json({
                                success: false,
                                message: "credentials mismatch"
                            })
                    }
                })
                .catch(err => {
                    console.log(err);
                    res.json({success: false, message: "Internal server error"})
                })
        })
        .catch(err => {
            console.log(err);
            res.json({success: false, message: "Internal server error"})
        })
});

//@type POST
//@route /auth/forgotpassword
//@desc Send OTP to user email to reset password
//@access PUBLIC

router.post("/forgotpassword", (req, res) => {
    const email = req.body.email;
    User.findOne({ email })
        .then(user => {
            if (!user) {
                return res.json({ success: false, message: "Email not exists" });
            }
            var uniquecode = Math.floor(1000 + Math.random() * 9000);
            User.findOneAndUpdate({ email: user.email }, { $set: { code: uniquecode } })
                .then(success => {
                    const msg = {
                        from: 'service.mytodoapp@gmail.com',
                        to: success.email,
                        subject: 'Password reset Code',
                        text: 'Your are requested to change your password. Here is the code to reset your password',
                        html: '<head><title>Forgot Your Password</title><meta content="text/html; charset=utf-8" http-equiv="Content-Type"><meta content="width=device-width" name="viewport"><style media="screen and (max-width: 680px)">@media screen and (max-width: 680px){.page-center{padding-left:0 !important;padding-right:0 !important}}</style></head><body style="background-color: #f4f4f5;"><table cellpadding="0" cellspacing="0" style="width: 100%; height: 100%; background-color: #f4f4f5; text-align: center;"><tbody><tr><td style="text-align: center;"><table align="center" cellpadding="0" cellspacing="0" id="body" style="background-color: #fff; width: 100%; max-width: 680px; height: 100%;"><tbody><tr><td><table align="center" cellpadding="0" cellspacing="0" class="page-center" style="text-align: left; padding-bottom: 88px; width: 100%; padding-left: 120px; padding-right: 120px;"><tbody><tr><td colspan="2" style="padding-top: 72px; -ms-text-size-adjust: 100%; -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: 100%; color: #000000; font-family: sans-serif; font-size: 48px; font-smoothing: always; font-style: normal; font-weight: 600; letter-spacing: -2.6px; line-height: 52px; mso-line-height-rule: exactly; text-decoration: none;">Forgot your password</td></tr><tr><td style="padding-top: 48px; padding-bottom: 48px;"><table cellpadding="0" cellspacing="0" style="width: 100%"><tbody><tr><td style="width: 100%; height: 1px; max-height: 1px; background-color: #d9dbe0; opacity: 0.81"></td></tr></tbody></table></td></tr><tr><td style="-ms-text-size-adjust: 100%; -ms-text-size-adjust: 100%; -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: 100%; color: #9095a2; font-family: sans-serif; font-size: 16px; font-smoothing: always; font-style: normal; font-weight: 400; letter-spacing: -0.18px; line-height: 24px; mso-line-height-rule: exactly; text-decoration: none; vertical-align: top; width: 100%;"> Thats okay, it happens! go to mytodoapp and enter code to reset your password</td></tr><tr><td colspan="2" style="padding-top: 30px; -ms-text-size-adjust: 100%; -webkit-font-smoothing: antialiased; -webkit-text-size-adjust: 100%; color: #000000; font-family: sans-serif; font-size: 40px; font-smoothing: always; font-style: normal; font-weight: 600; letter-spacing: -2.6px; line-height: 52px; mso-line-height-rule: exactly; text-decoration: none;">' + uniquecode + '</td></tr></tbody></table></td></tr></tbody></table></body>'
                    };
                    transporter.sendMail(msg, (error, info) => {
                        if (error) {
                            console.log(error);
                            res.json({success: false, message: "Internal server error1"})
                        } else {
                            return res.json({ success: true, message: "A mail is sended with reset code to your registered email. Please check your mail." });
                        }
                    });
                }).catch(err => {
                    console.log(err);
                    res.json({success: false, message: "Internal server error2"})
                })
        })
        .catch(err => {
            console.log(err);
            res.json({success: false, message: "Internal server error3"})
        })
});

//@type POST
//@route /auth/resetpassword
//@desc Reset password
//@access PUBLIC

router.post("/resetpassword", (req, res) => {
    const email = req.body.email;
    const code = req.body.code;
    const password = req.body.password;
    User.findOne({ email })
        .then(user => {
                if (!user) {
                    return res.json({ success: false, message: "Email not exists" });
                } else if (user.code != code || code === null) {
                    return res.json({ success: false, message: "Please enter valid code" });
                } else {
                    bcrypt.genSalt(10, (err, salt) => {
                        bcrypt.hash(password, salt, (err, hash) => {
                            if (err) throw err;
                            User.findOneAndUpdate({ email: user.email }, { $set: { code: null } }).findOneAndUpdate({ email: user.email }, { $set: { password: hash } })
                                .then(success => {
                                    return res.json({ success: true, message: "Password updated successfully" })
                                }).catch(err => {
                                    console.log(err);
                                    res.json({success: false, message: "Internal server error"})
                                })
                        });
                    });
                }
            }

        )
        .catch(err => {
            console.log(err);
            res.json({success: false, message: "Internal server error"})
        })
});

module.exports = router;