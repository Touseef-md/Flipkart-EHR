// require("dotenv").config();
// const mongoose = require("mongoose");
const express = require("express");
const bodyParser = require("body-parser");
// const { ObjectId } = require("mongodb");

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.get("/", (req, res) => {
    console.log('Get request reveived...');
    console.log('request is $req');
    // Auth.find({}, (err, found) => {
    //   if (!err) {
    //     res.send(found);
    //   } else {
    //     console.log(err);
    //     res.send("Some error occured");
    //   }
    // })
    //   .clone()
    //   .catch((err) => console.log("Error occured, " + err));
  });


app.listen(3000, () => {
  console.log("Server is running");
});
