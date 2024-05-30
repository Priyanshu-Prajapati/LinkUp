import express from "express";
import { MongoClient } from "mongodb";
import path from "path";
import bcrypt from "bcrypt";
import mongoose from "mongoose";
import jwt from "jsonwebtoken";
import cookieParser from "cookie-parser";

const bodyParser = require("body-parser");

async function start() {
  // const url = `mongodb+srv://priyanshu18032003:Priyanshu6535@cluster0.rn98rof.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0`;
  const url = `mongodb://localhost:27017`;
  const Mongoclient = new MongoClient(url);

  await Mongoclient.connect();
  const db = Mongoclient.db("FullStack-Database");

  mongoose.connect(
    // "mongodb+srv://priyanshu18032003:Priyanshu6535@cluster0.rn98rof.mongodb.net/registeredUsers?retryWrites=true&w=majority&appName=Cluster0",
    "mongodb://localhost:27017/registeredUsers",
    console.log("Connected To the Database!")
  );

  const app = express();
  app.use(express.json());

  app.use(cookieParser());

  app.use(bodyParser.json());

  app.post("/user_message", async (req, res) => {
    const { id, message, email, date, heartCounter } = req.body;

    // Here you can process the received data as per your requirement
    console.log("Received Data:");
    console.log("Id:", id);
    console.log("Message:", message);
    console.log("Email:", email);
    console.log("Date:", date);
    console.log("HeartCounter", heartCounter);
    res.send('REceived the data From the flutter');
    await db.collection('user_messages').insertOne({id: id, message: message, email: email, date: date});
  });

  app.get("/fetch-data", async (req, res) => {
    try {
      const collection = db.collection('user_messages');
  
      // Fetch data from MongoDB
      const data = await collection.find({}).toArray();
  
      // Send the data as JSON response
      res.status(200).json(data);
    } catch (error) {
      console.error('Error fetching data:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });

  app.post("/update-counter", async (req, res) => {
    const { counter, id, isLiked } = req.body;
    console.log('Counter count: ', counter);
    await db.collection('user_messages').findOneAndUpdate({id: id}, {$set: {counter: counter, isLiked: isLiked}});

  });

  app.get("/get-counter/:id", async (req, res) => {
    const messageId = req.params.id;
  
    try {
      // Find the message with the given ID
      const message = await db.collection('user_messages').findOne({ id: messageId });
  
      if (!message) {
        return res.status(404).json({ error: 'Message not found' });
      }
  
      // Send the counter of the message as JSON response
      res.status(200).json({ counter: message.counter});
    } catch (error) {
      console.error('Error fetching counter:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  });
  

  app.listen(8000, () => {
    console.log("Server is listening on port 8000");
  });
}

start();
