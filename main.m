function main
    % Create a figure window and set the resize function
    guiFig = figure('Visible','off','Position',[360,200,700,800], 'ResizeFcn', @resizeUI);
    %% add to path
    addpath(genpath(fullfile("functionasRelatedParameters")));
    addpath(genpath(fullfile("myOptimizationAlgo")));
    addpath(genpath(fullfile("OperationFuncs")));
    addpath(genpath(fullfile("usefulFunctions")));
    % Define default values for all variables
    defaultPath = 'avgStrainStressInfoNEPureShearLoading.csv';
    defaultPsi = ['1/params(1) * (J-1)^2        + ...', newline, ...
                  'params(2) * (I1-3) + ...', newline, ...
                  'params(3) * (I4-1)+  ...', newline, ...
                  'params(4) * (I4-1)^2 ;'];
    defaultSave = 'theta.mat';
    defaultAi = '[1;0;0]';
    defaultBatchSize = '300';
    defaultLearningRate = '1e-4';
    defaultMaxIterations = '5e6';
    defaultPrintEvery = '50';
    defaultModelTitle = '$\Psi = c_1 \left(J-1\right)^2 + c_2 \left( \bar{I}_1 -3 \right) + c_3 \left(\bar{I}_4-1\right)+ c_4 \left(\bar{I}_4-1\right)^2 $';
    defaultFolderName = 'model1';

    % Initialize positions for the new controls
    yPos = 0.95; % Starting y position
    height = 0.05; % Height for each control
    gap = 0.005; % Gap between controls
    psiHeight = 3 * height; % Special height for Psi text box

    % Helper function to calculate positions
    newPos = @(yPos, h) [0.3, yPos, 0.6, h];
    labelPos = @(yPos, h) [0.05, yPos + h/2 - 0.025, 0.25, height];

    % Create text boxes with normalized units for resizing
    txtBoxPath = uicontrol('Style','edit','Units','normalized','Position',newPos(yPos-height-gap, height),'String',defaultPath,'Parent', guiFig);
    txtBoxPsi = uicontrol('Style','edit','Units','normalized','Position',[0.3, yPos-4*height, 0.6, psiHeight],'String',defaultPsi, 'Max', 2, 'Min',0,'Parent', guiFig);
    txtBoxSave = uicontrol('Style','edit','Units','normalized','Position',newPos(yPos-5*height-2*gap, height),'String',defaultSave,'Parent', guiFig);
    txtBoxAi = uicontrol('Style','edit','Units','normalized','Position',newPos(yPos-6*height-3*gap, height),'String',defaultAi,'Parent', guiFig);
    txtBoxBatchSize = uicontrol('Style','edit','Units','normalized','Position',newPos(yPos-7*height-4*gap, height),'String',defaultBatchSize,'Parent', guiFig);
    txtBoxLearningRate = uicontrol('Style','edit','Units','normalized','Position',newPos(yPos-8*height-5*gap, height),'String',defaultLearningRate,'Parent', guiFig);
    txtBoxMaxIterations = uicontrol('Style','edit','Units','normalized','Position',newPos(yPos-9*height-6*gap, height),'String',defaultMaxIterations,'Parent', guiFig);
    txtBoxPrintEvery = uicontrol('Style','edit','Units','normalized','Position',newPos(yPos-10*height-7*gap, height),'String',defaultPrintEvery,'Parent', guiFig);
    txtBoxModelTitle = uicontrol('Style','edit','Units','normalized','Position',newPos(yPos-11*height-8*gap, height),'String',defaultModelTitle,'Parent', guiFig);
    txtBoxFolderName = uicontrol('Style','edit','Units','normalized','Position',newPos(yPos-12*height-9*gap, height),'String',defaultFolderName,'Parent', guiFig);

    % Store the uicontrol handles in arrays for easy access
    textboxes = [txtBoxPath, txtBoxPsi, txtBoxSave, txtBoxAi, txtBoxBatchSize, ...
                 txtBoxLearningRate, txtBoxMaxIterations, txtBoxPrintEvery, ...
                 txtBoxModelTitle, txtBoxFolderName];
    labels = {'CSV Load File Path', 'Ψ', 'Parameter File Name', 'ai', 'batch_size', ...
              'learning_rate', 'max_iterations', 'print_every', 'model_data.title', 'model_data.folder_name'};
    labelHandles = gobjects(1, length(labels)); % Preallocate for label handles

    % Create labels aligned with text boxes
    for i = 1:length(labels)
        if i==2
            h =psiHeight;
        else
            h = height;
        end
         % Use special height for Psi label
        labelHandles(i) = uicontrol('Style','text','Units','normalized','Position',labelPos(yPos-i*(height+gap), h), 'String',labels{i},'Parent', guiFig);
    end

    % Set the ResizeFcn of the figure
     % Set the ResizeFcn of the figure
    set(guiFig, 'ResizeFcn', @(src, evt) resizeUI(src, evt, textboxes, labelHandles, psiHeight, height))

    
    % Make the figure visible
    guiFig.Visible = 'on';

    % Resize function to adjust UI components when the figure is resized
    function resizeUI(src, eventdata, textboxes, labelHandles, psiHeight, height)
        if src == guiFig
            % Iterate over each label to update its position
            for i = 1:length(labelHandles)
                if i==2
                    h =psiHeight;
                else
                    h = height;
                end % Use special height for Psi text box
                textBoxPosition = textboxes(i).Position;
                % Update label position to align with the text box
                labelHandles(i).Position = [labelHandles(i).Position(1), ...
                                            textBoxPosition(2) + h/2 - labelHandles(i).Position(4)/2, ...
                                            labelHandles(i).Position(3), ...
                                            labelHandles(i).Position(4)];
            end
        end
    end

    % Callback function for the generate button
    btn = uicontrol('Style','pushbutton','Units','normalized','String','Generate',...
                    'Position',[0.35,0.05,0.3,0.1],'Callback',{@generate_callback});


    % Callback function for the generate button
    function generate_callback(source,eventdata) 
        % Here you would include the code that should be executed
        % Check the validity of inputs
        [isValid, errorMessage] = validateInputs(txtBoxMaxIterations, txtBoxLearningRate, txtBoxBatchSize, ...
                                                  txtBoxAi, txtBoxModelTitle, txtBoxFolderName, ...
                                                  txtBoxPsi, txtBoxPath, txtBoxSave);
    
        % If any input is invalid, display the error message and stop
        if ~isValid
            disp(['Error: ', errorMessage]);
            return;
        end
        % when the Generate button is pressed
        disp('Generate button pressed');
        % Retrieve values from text boxes if needed
        filepath = txtBoxPath.String;
        psiMatrix_char = txtBoxPsi.String;

        parameter_file_name = txtBoxSave.String;
         % Retrieve ai string from the text box
        aiString = txtBoxAi.String;

        ai =  extractAiVector(aiString);
        batch_size = str2num(txtBoxBatchSize.String);
        learning_rate = str2double(txtBoxLearningRate.String);
        max_iterations = str2num(txtBoxMaxIterations.String);
        print_every = str2num(txtBoxPrintEvery.String);
        model_data.title =txtBoxModelTitle.String; 
        model_data.folder_name = txtBoxFolderName.String;

        % Flatten the character matrix into a single string
        % Initialize an empty string
        psiString = '';
    
        % Loop over each row of the char matrix and concatenate
        for i = 1:size(psiMatrix_char, 1)
            psiString = [psiString, strtrim(psiMatrix_char(i, :))];
        end
        num_params = calculateParamLength(psiString);
        theta = rand(1,num_params);
        psiStr = strrep(psiString,'...','');
        % Generating derivatives
        der_U_byStr(num_params,psiStr);
        
        % Create folder where mat file and figures will be saved
        createSubfolders(fullfile('figures',model_data.folder_name));
        [T,epsMatrix,sigDevMatrix,sigMatrix]=readData(filepath);
        
        sprev = rng(0,'v5uniform');
        [I1barList,I2barList, ...
                    I3List, ...
                    I4barList,I5barList, ...
                    Base1List, ...
                    Base2List, ...
                    Base4List, ...
                    Base5List ...
                    ] ...
                    =get_requiredValues(epsMatrix,ai);
        %%
        
        obj = @(params)gradCalculation(params,I1barList, ...
                        I2barList, ...
                        I3List, ...
                        I4barList, ...
                        I5barList, ...
                        Base1List, ...
                        Base2List, ...
                        Base4List, ...
                        Base5List,sigMatrix,batch_size);
        % load("theta.mat");
        
        %%
        
        
        [theta, J_history,theta_best] = adam_optimizer(theta,obj  ...
                                        , learning_rate, ...
                                        max_iterations, ...
                                        print_every,model_data, ...
                                        epsMatrix, ...
                                        sigMatrix, ...
                                        ai, ...
                                        parameter_file_name);
        
    end
end


function createSubfolders(relativePath)
    % Check if the folder already exists
    if ~exist(relativePath, 'dir')
        % If the folder does not exist, create it
        [status, msg, msgID] = mkdir(relativePath);
        
        % Check if the operation was successful
        if status == 0
            % If an error occurred, display the error message
            error(msgID, msg);
        else
            disp(['Folder "', relativePath, '" has been created successfully.']);
        end
    else
        % If the folder exists, display a message
        disp(['Folder "', relativePath, '" already exists.']);
    end
end




function paramLength = calculateParamLength(psiString)
    % Flatten the character matrix into a single string
    % Initialize an empty string

    
    % Find all occurrences of 'params(' and get indices
    startIndices = strfind(psiString, 'params(');
    
    % Initialize an array to store parameter indices
    paramIndices = [];

    % Loop through each occurrence to extract the index
    for i = 1:length(startIndices)
        startIndex = startIndices(i) + length('params(');
        % Find the closing parenthesis
        endIndex = find(psiString(startIndex:end) == ')', 1, 'first') + startIndex - 2;
        % Extract the index and convert it to a number
        paramIndex = str2double(psiString(startIndex:endIndex));
        % Append to the array of indices
        paramIndices = [paramIndices, paramIndex];
    end

    % Get the unique indices and count them
    paramLength = length(unique(paramIndices));
end

function aiVector = extractAiVector(aiString)
    % Remove square brackets if present
    aiString = strrep(aiString, '[', '');
    aiString = strrep(aiString, ']', '');

    % Split the string by semicolons or newlines to get individual elements
    elements = regexp(aiString, '[;\n]', 'split');
    
    % Remove any empty cells caused by splitting
    elements = elements(~cellfun('isempty',elements));
    
    % Convert the string elements to numbers
    aiVector = cellfun(@str2double, elements);
    
    % Ensure the output is a column vector
    aiVector = aiVector(:);
end


function [isValid, message] = validateInputs(txtBoxMaxIterations, txtBoxLearningRate, txtBoxBatchSize, ... % Add other text box handles as parameters
                                             txtBoxAi, txtBoxModelTitle, txtBoxFolderName, ... % Continue adding other text box handles
                                             txtBoxPsi, txtBoxPath, txtBoxSave) % Add the remaining text box handles
    % Initialize the output
    isValid = true;
    message = '';

    % Validate Max Iterations (should be a non-negative integer)
    maxIterations = str2double(txtBoxMaxIterations.String);
    if isnan(maxIterations) || maxIterations < 0 || floor(maxIterations) ~= maxIterations
        isValid = false;
        message = 'Max Iterations must be a non-negative integer.';
        return;
    end

    % Validate Learning Rate (should be a positive number)
    learningRate = str2double(txtBoxLearningRate.String);
    if isnan(learningRate) || learningRate <= 0
        isValid = false;
        message = 'Learning Rate must be a positive number.';
        return;
    end

    % Validate Batch Size (should be a positive integer)
    batchSize = str2double(txtBoxBatchSize.String);
    if isnan(batchSize) || batchSize <= 0 || floor(batchSize) ~= batchSize
        isValid = false;
        message = 'Batch Size must be a positive integer.';
        return;
    end

    % ... Add similar validations for other inputs ...

    % Example: Validate Ai (should be a numeric vector)
    try
        ai = extractAiVector(txtBoxAi.String); % Assuming extractAiVector is defined as previously discussed
        if isempty(ai) || any(isnan(ai))
            throw(MException('',''));
        end
    catch
        isValid = false;
        message = 'Ai must be a valid numeric vector.';
        return;
    end

    % Validate CSV Load Path
    csvLoadPath = txtBoxPath.String;
    if exist(csvLoadPath, 'file') ~= 2
        isValid = false;
        message = 'CSV Load Path does not point to a valid file.';
        return;
    else
        % Check if the file is a CSV with 13 columns
        try
            data = readtable(csvLoadPath);
            if size(data, 2) ~= 13
                isValid = false;
                message = 'The CSV file must have exactly 13 columns.';
                return;
            end
        catch
            isValid = false;
            message = 'Error reading the CSV file. Ensure it is properly formatted.';
            return;
        end
    end

    % ... Continue with other validations ...
end

