#!/bin/bash

"""
This script automates and identifies the best baseline model.
It also generates a report that contains the model name, Data version,
metrics and confusion matrix.

"""
# Define paths
REPORT_DIR="./reports"
RESULTS_FILE="$REPORT_DIR/baseline_model_results.csv"
OUTPUT_FILE="$REPORT_DIR/baseline_model_report.md"

# Ensure the results file exists
if [[ ! -f "$RESULTS_FILE" ]]; then
    echo "Error: $RESULTS_FILE not found!"
    exit 1
fi

# Extract the best model based on F1-score
BEST_MODEL=$(awk -F',' 'NR==1 {next} {print $0 | "sort -t, -k5,5nr"}' "$RESULTS_FILE" | head -n 1)

# Ensure we have data
if [[ -z "$BEST_MODEL" ]]; then
    echo "Error: No valid model data found!"
    exit 1
fi

# Extract fields
DATA_VERSION=$(echo "$BEST_MODEL" | awk -F',' '{print $1}')
MODEL_NAME=$(echo "$BEST_MODEL" | awk -F',' '{print $2}')
PRECISION=$(echo "$BEST_MODEL" | awk -F',' '{print $3}')
RECALL=$(echo "$BEST_MODEL" | awk -F',' '{print $4}')
F1_SCORE=$(echo "$BEST_MODEL" | awk -F',' '{print $5}')
ROC_AUC=$(echo "$BEST_MODEL" | awk -F',' '{print $6}')
CONF_MATRIX_FILE="$REPORT_DIR/${DATA_VERSION}_${MODEL_NAME}_confusion_matrix.png"

# Generate Markdown report
echo "# Baseline Model Evaluation" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "- Model: $MODEL_NAME" >> "$OUTPUT_FILE"
echo "- Data Version: $DATA_VERSION" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "## Metrics" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "- F1-score: $F1_SCORE" >> "$OUTPUT_FILE"
echo "- Recall: $RECALL" >> "$OUTPUT_FILE"
echo "- Precision: $PRECISION" >> "$OUTPUT_FILE"
echo "- ROC-AUC: $ROC_AUC" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "## Confusion Matrix:" >> "$OUTPUT_FILE"
echo "![Confusion Matrix](./${DATA_VERSION}_${MODEL_NAME}_confusion_matrix.png)" >> "$OUTPUT_FILE"

echo "Report generated: $OUTPUT_FILE"

