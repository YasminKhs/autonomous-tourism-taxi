# Autonomous Tourism Taxi

A UNHack 2026 team project exploring how autonomous taxis can make sightseeing easier, safer, and more accessible.

## The Problem
Exploring an unfamiliar city involves planning routes, navigating language barriers, and repeatedly booking transportation. These tasks add stress for tourists, especially families and older travellers.

## Our Concept
A tourism service that combines personalized sightseeing plans with a dedicated autonomous vehicle.

Visitors select attractions through photos, receive an itinerary, and travel between stops in a vehicle that waits while they explore.

## Proposed Features
- Photo-based attraction selection
- Personalized sightseeing itineraries
- Multilingual support
- Multi-stop trips with waiting time included
- Attention to passenger safety and accessibility during pickups and drop-offs

## Safety and Accessibility
Our concept considers the needs of families, older travellers, and passengers with accessibility needs. The aim is to make boarding, travel, and pickup and drop-off experiences easier and safer.

## Project Status
Developed as a hackathon concept with prototype work. The features above describe the proposed service.

## Team
Developed collaboratively by our UNHack team.

## Driving Simulation
Our team worked on an autonomous taxi simulation using MATLAB, Simulink, and Quanser QLabs.

The simulation demonstrates:
- Navigation around the simulated road map
- Travel to specified pickup and drop-off locations
- Traffic-rule handling, including stopping at stop signs and yielding

This demonstration was performed in a simulated environment.

[View or download the simulation video](taxi-simulation.mp4)

## My Contribution
I worked on configuring and troubleshooting the autonomous taxi simulation using MATLAB, Simulink, and Quanser QLabs.

My work focused on:
- Investigating QCar2 runtime startup and HIL connection errors
- Working through camera configuration and RealSense device-name issues
- Running the simulation, reporting errors, and testing proposed fixes
- Exploring an arrival planner in a separate experimental model

I used AI-assisted development and debugging throughout this process.

The project demonstration shows the simulated car navigating the map, travelling between specified pickup and drop-off locations, and responding to traffic rules. The experimental arrival planner is separate from this demonstration.

## Presentation
Our pitch presents RoboTaxi Trips, the tourism service concept behind this project, including the visitor experience and business model.

[Download the pitch deck](pitch-deck.pptx)
## Simulation Files
The `simulation` folder contains the Simulink model, passenger-stop controller, setup scripts, and passenger-stop documentation.

The passenger-stop controller:
- Uses specified pickup and drop-off coordinates
- Issues a five-second stop command at each location
- Resumes the existing route after each stop
- Completes one pickup and drop-off mission per simulation run

The five-second timer begins when the stop command is issued, including the initial braking interval.

[Read the passenger-stop documentation](simulation/PASSENGER_STOPS.md)

## Software Requirements
Running the simulation requires:
- Windows
- MATLAB and Simulink
- Quanser Interactive Labs with the QCar2 environment
- Quanser QUARC and supporting libraries
- The original competition resources, including additional parameter scripts, data, and detection assets

This repository contains selected project files. The original competition environment and supporting resources are also required to run the model.

## Team and Credits
Developed for UNHack 2026 by team UN-Handled Exception:
- Hasita Mandaleeka
- Reza Danesh Askari
- Yasamin Khorsandpour
- Samantha Murillo

The simulation builds on the Quanser and MathWorks competition starter resources.