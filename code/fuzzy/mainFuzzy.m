
% Read data from CSV file
data = readtable('data.csv');

% Assuming the dataset has 32 columns
num_columns = size(data, 2);

if num_columns == 32
    % Extract the second column
    second_column = data(:, 2);
    
    % Remove the second column from the dataset
    data(:, 2) = [];
    data(:, 1) = [];
    
    % Append the second column at the end
    data = [data, second_column];
    
    % Optionally, save the modified dataset to a new CSV file
    % csvwrite('modified_dataset.csv', data);
else
    disp('Error: Dataset does not have 32 columns.');
end

% Extract input and output columns
output = data(:, 31); % Assuming the output is in the second column
input = data(:, 1:30); % Assuming input starts from the third column

% Data preprocessing: Normalization
input_normalized = normalize(input); % Normalization along each feature (column)

% Split dataset into training, testing, and validation sets
% Define proportions for each set (e.g., 60% training, 20% testing, 20% validation)
train_ratio = 0.6;
test_ratio = 0.2;
val_ratio = 0.2;

% Calculate sizes for each set
num_samples = size(data, 1);
num_train = round(train_ratio * num_samples);
num_test = round(test_ratio * num_samples);
num_val = num_samples - num_train - num_test;

% Shuffle indices to randomize data
indices = randperm(num_samples);

% Split data based on shuffled indices
train_indices = indices(1:num_train);
test_indices = indices(num_train+1:num_train+num_test);
val_indices = indices(num_train+num_test+1:end);

% Split data into sets
train_input = input_normalized(train_indices, :);
train_output = output(train_indices, :);

test_input = input_normalized(test_indices, :);
test_output = output(test_indices, :);

val_input = input_normalized(val_indices, :);
val_output = output(val_indices, :);

% Convert datasets to doubles
train_input = table2array(train_input);
train_output = table2array(train_output);

test_input = table2array(test_input);
test_output = table2array(test_output);

val_input = table2array(val_input);
val_output = table2array(val_output);

% Now you have training, testing, and validation sets as arrays of doubles


tic;

fcmOpt = fcmOptions(...
 NumClusters=2,...
 Exponent=2.0, ...
 MaxNumIteration=100, ...
 MinImprovement=1e-6);

%[centers,U] = fcm([train_input, second_column],options);

opt = genfisOptions("FCMClustering");
opt.NumClusters = fcmOpt.NumClusters;
opt.Exponent = fcmOpt.Exponent;
opt.MaxNumIteration = fcmOpt.MaxNumIteration;
opt.MinImprovement = fcmOpt.MinImprovement;

fis = genfis(train_input,train_output,opt);

showrule(fis)

epoch_num = 10;

fis_anfis = anfis([train_input train_output], fis, epoch_num);

 elapsedTime = toc;
    
    % Display runtime
    fprintf('Elapsed time: %.4f seconds\n', elapsedTime);

% Test the fuzzy inference system
output_pred = evalfis(test_input, fis_anfis);

% Convert predicted output to binary labels
predicted_labels = round(output_pred);

% Generate confusion matrix
C = confusionmat(test_output, predicted_labels);

% Display confusion matrix
disp('Confusion Matrix:');
% Display confusion matrix using confusionchart
confusionchart(test_output, predicted_labels, 'RowSummary','row-normalized', 'ColumnSummary','column-normalized');
title('Confusion Matrix');

% Calculate accuracy
accuracy = sum(diag(C)) / sum(C(:));
disp(['Accuracy: ', num2str(accuracy)]);

%Accuracy: 0.98246
%Minimal training RMSE = 0.186858