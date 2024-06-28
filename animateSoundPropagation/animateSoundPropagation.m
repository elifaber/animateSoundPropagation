function animateSoundPropagation(roomLength, roomWidth, roomHeight, drivingFrequency, sourcePoints, spldBs)
    % ANIMATESOUNDPROPAGATION simulates the propagation of sound waves in a room
    %   animateSoundPropagation(roomLength, roomWidth, roomHeight, drivingFrequency, sourcePoints, spldBs)
    %
    %   Inputs:
    %       roomLength      - Length of the room in meters
    %       roomWidth       - Width of the room in meters
    %       roomHeight      - Height of the room in meters
    %       drivingFrequency - Frequency of the driving sound source (not currently used in the simulation)
    %       sourcePoints    - Nx3 matrix where each row specifies the coordinates [x, y, z] of a sound source point in the room
    %       spldBs          - Array of sound pressure levels (in dB SPL) corresponding to each source point
    %
    %   Outputs:
    %       None
    %
    %   Sample Use Case:
    %       % Simulate sound propagation in a 5x5x3 meter room with a single source at the center emitting 110 dB SPL
    %       roomLength = 5; 
    %       roomWidth = 5;
    %       roomHeight = 3;
    %       sourcePoints = [roomLength/2, roomWidth/2, roomHeight/2];
    %       spldBs = 110;
    %       animateSoundPropagation(roomLength, roomWidth, roomHeight, [], sourcePoints, spldBs);
    %
    %   Note:
    %       This function assumes perfectly reflecting walls and does not currently account for frequency-dependent effects or absorption coefficients.
    %
    % Constants
    c = 343; % Speed of sound in air (m/s)
    tmax = 0.1; % Maximum simulation time (seconds)

    dx = max([roomLength,roomWidth,roomHeight])/100; % Grid spacing (meters)
    dt = dx/100; % Time step based on Nyquist criterion
    
    % Default source points (center of the room if not provided)
    if nargin < 5 || isempty(sourcePoints)
        sourcePoints = [roomLength / 2, roomWidth / 2, roomHeight / 2];
    end
    
    % Default SPLs if not provided
    if nargin < 6 || isempty(spldBs)
        spldBs = 110; % Default SPL in dB
    end
    
    % Calculate reference sound pressure (assuming SPL of 0 dB at 1 meter)
    pref = 20e-6; % Reference sound pressure in Pascal (for 0 dB SPL at 1 meter)
    refDist = 1; % Reference distance for SPL calculation
    
    % Spatial grid
    x = 0:dx:roomLength;
    y = 0:dx:roomWidth;
    z = 0:dx:roomHeight;
    [X, Y, Z] = meshgrid(x, y, z);
    
    % Create figure
    figure;
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    axis equal;
    grid on;
    hold on;
    
    % Main simulation loop
    for t = 0:dt:tmax
        for i = 1:size(sourcePoints, 1)
            % Current source point and SPL
            sourcePoint = sourcePoints(i, :);
            spldB = spldBs(i);
            
            % Calculate the spherical wavefront
            r = c * t; % Radius of the spherical wavefront at time t

            % Adjust SPL for the current propagation distance (inverse square law)
            spl = spldB - 20 * log10(r / refDist); % Adjusted SPL based on distance (inverse square law)

            % Determine color based on SPL value (adjust as needed)
            if spl >= 100
                color = [1, 0, 0]; % Red for SPL >= 100 dB
            elseif spl >= 90
                color = [1, 0.5, 0]; % Orange for 90 <= SPL < 100 dB
            elseif spl >= 80
                color = [.9, .9, .1]; % Yellow for 80 <= SPL < 90 dB
            elseif spl >= 70
                color = [0, 1, 0]; % Green for 70 <= SPL < 80 dB
            elseif spl >= 60
                color = [0, 1, 1]; % Light blue for 60 <= SPL < 70 dB
            else
                color = [0, 0, 1]; % Dark blue for SPL < 60 dB
            end

            % Calculate spherical wavefront coordinates
            [sphereX, sphereY, sphereZ] = sphere(100); % Generate spherical coordinates
            wavefrontX = r * sphereX + sourcePoint(1); % X coordinates of sphere
            wavefrontY = r * sphereY + sourcePoint(2); % Y coordinates of sphere
            wavefrontZ = r * sphereZ + sourcePoint(3); % Z coordinates of sphere
            
            % Plot the spherical wavefront with adjusted color and opacity
            surf(wavefrontX, wavefrontY, wavefrontZ, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.8); % Adjusted opacity

            % Calculate reflections off walls (assuming perfectly reflecting walls)
            % Reflections from x = 0 and x = roomLength walls
            reflectX1 = 2 * (0 - sourcePoint(1)) + wavefrontX;
            reflectX2 = 2 * (roomLength - sourcePoint(1)) + wavefrontX;

            % Reflections from y = 0 and y = roomWidth walls
            reflectY1 = 2 * (0 - sourcePoint(2)) + wavefrontY;
            reflectY2 = 2 * (roomWidth - sourcePoint(2)) + wavefrontY;

            % Reflections from z = 0 and z = roomHeight walls
            reflectZ1 = 2 * (0 - sourcePoint(3)) + wavefrontZ;
            reflectZ2 = 2 * (roomHeight - sourcePoint(3)) + wavefrontZ;

            % Plot the reflected wavefronts with adjusted color and opacity
            surf(reflectX1, wavefrontY, wavefrontZ, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.8); % Reflection off x = 0 wall
            surf(reflectX2, wavefrontY, wavefrontZ, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.8); % Reflection off x = roomLength wall
            surf(wavefrontX, reflectY1, wavefrontZ, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.8); % Reflection off y = 0 wall
            surf(wavefrontX, reflectY2, wavefrontZ, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.8); % Reflection off y = roomWidth wall
            surf(wavefrontX, wavefrontY, reflectZ1, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.8); % Reflection off z = 0 wall
            surf(wavefrontX, wavefrontY, reflectZ2, 'FaceColor', color, 'EdgeColor', 'none', 'FaceAlpha', 0.8); % Reflection off z = roomHeight wall
        end

        % Update figure properties
        xlabel('X');
        ylabel('Y');
        zlabel('Z');
        title(['Propagation of Sound at t = ', num2str(t), ' seconds']);
        axis([0 roomLength 0 roomWidth 0 roomHeight]); % Set axis limits to room dimensions
        view(3); % 3D view

        % Pause to control animation speed
        pause(0.1);

        % Clear plot for next iteration (comment out if you want to see animation over time)
        cla;
    end
end
