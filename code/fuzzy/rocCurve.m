% Assuming you have predicted scores from your ANFIS system and true labels

% Example predicted scores and true labels (replace these with your actual data)
scores = output_pred; % Example predicted scores (probability estimates)
true_labels = test_output; % Example true labels (binary: 0 or 1)

% Calculate false positive rate (FPR) and true positive rate (TPR) for different thresholds
[~, ~, ~, AUC] = perfcurve(true_labels, scores,1);
fprintf('Area under ROC curve (AUC): %.4f\n', AUC);

% Plot ROC curve
figure;
plotroc(true_labels, scores);
title('ROC Curve for ANFIS Fuzzy System');
