% Define room dimensions
roomLength = 10; % meters
roomWidth = 30; % meters
roomHeight = 20; % meters

% Define source points and SPLs
sourcePoints = [
    1, 1, 10;   % Source 1 position (x, y, z)
    9, 29, 10;   % Source 2 position (x, y, z)
];
spldBs = [110, 100, 105]; % SPL in dB for each source

% Call the function to animate sound propagation
animateSoundPropagation(roomLength, roomWidth, roomHeight, [], sourcePoints, spldBs);
