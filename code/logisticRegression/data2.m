% Load your dataset (replace 'your_dataset.csv' with the actual file path)
data2 = readtable('data.csv');

% Assuming the dataset has 32 columns
num_columns = size(data2, 2);

if num_columns == 32
    % Extract the second column
    second_column = data2(:, 2);
    
    % Remove the second column from the dataset
    data2(:, 2) = [];
    
    % Append the second column at the end
    data2 = [data2, second_column];
    
    % Display the modified dataset
    disp('Modified Dataset:');
    disp(data2);
    
    % Optionally, save the modified dataset to a new CSV file
    % csvwrite('modified_dataset.csv', data);
else
    disp('Error: Dataset does not have 32 columns.');
end
