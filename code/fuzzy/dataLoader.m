
% Read data from CSV file
data = readtable('data.csv');

% Extract input and output columns
output = data(:, 2); % Assuming the output is in the second column
input = data(:, 3:end); % Assuming input starts from the third column

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
