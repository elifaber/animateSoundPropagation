animateSoundPropagation
=======================================

Description
-----------
The animateSoundPropagation function simulates the propagation of sound waves in a 3D room environment. It visualizes how sound waves emanate from specified source points and reflect off the walls of the room.

Functionality
-------------
The function generates a dynamic 3D animation where:
- Sound sources are represented by colored spherical wavefronts.
- Reflections of sound waves off the room walls are visualized.

Inputs
------
1. roomLength - Length of the room in meters.
2. roomWidth - Width of the room in meters.
3. roomHeight - Height of the room in meters.
4. drivingFrequency - Frequency of the driving sound source (not currently used in the simulation).
5. sourcePoints - Nx3 matrix where each row specifies the coordinates [x, y, z] of a sound source point in the room.
6. spldBs - Array of sound pressure levels (in dB SPL) corresponding to each source point.

Usage
-----
To use the function, provide the dimensions of the room (roomLength, roomWidth, roomHeight), specify the source points (sourcePoints) and their respective sound pressure levels (spldBs). The function will animate the propagation of sound waves from these sources within the room.

Example usage: see testing file


Notes
-----
- The simulation assumes perfectly reflecting walls (no absorption).
- Currently, the function does not account for frequency-dependent effects.
