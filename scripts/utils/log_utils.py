import os
import json
import time
import platform
import psutil
import joblib
import numpy as np
import pandas as pd
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score

# Absolute Project Root
PROJECT_ROOT = r"C:\Projects\GitHub\Ireland-energy-forecast"
LOGS_FOLDER = os.path.join(PROJECT_ROOT, "outputs", "logs")
os.makedirs(LOGS_FOLDER, exist_ok=True)

print("Project Root LOCKED:", PROJECT_ROOT)



def log_model_performance(
    model_name,
    target_variable,
    X_train,
    X_test,
    y_test,
    y_pred,
    model_object,
    training_time_sec,
    dataset_name="Final_Wind_Data_Model",
    tuning_type="None",
    gpu_used="NVIDIA GeForce RTX 2050",
    prediction_interval_width=None,
    shap_top_features=None,
    shap_waterfall_sample_id=None,
    extra_notes=""
):
    mae = mean_absolute_error(y_test, y_pred)
    rmse = np.sqrt(mean_squared_error(y_test, y_pred))
    r2 = r2_score(y_test, y_pred)

    start_infer = time.time()
    _ = model_object.predict(X_test[:1])
    inference_time = round(time.time() - start_infer, 6)

    joblib.dump(model_object, "temp_model.pkl")
    model_size_mb = round(os.path.getsize("temp_model.pkl") / 1e6, 2)
    os.remove("temp_model.pkl")

    log_dict = {
        "model_name": model_name,
        "target": target_variable,
        "dataset_used": dataset_name,
        "training_samples": X_train.shape[0],
        "test_samples": X_test.shape[0],
        "n_features": X_train.shape[1],
        "input_shape": str(X_train.shape),
        "mae": round(mae, 2),
        "rmse": round(rmse, 2),
        "r2_score": round(r2, 3),
        "training_time_sec": round(training_time_sec, 2),
        "inference_time_per_sample_sec": inference_time,
        "model_size_mb": model_size_mb,
        "tuning_type": tuning_type,
        "training_date": pd.Timestamp.now().strftime("%Y-%m-%d %H:%M:%S"),
        "prediction_interval_width": prediction_interval_width,
        "shap_top_features": shap_top_features,
        "shap_waterfall_sample_id": shap_waterfall_sample_id,
        "model_file_path": f"models/{model_name}.joblib",
        "platform": platform.system(),
        "platform_version": platform.version(),
        "processor": platform.processor(),
        "cpu_count": psutil.cpu_count(logical=True),
        "gpu_used": gpu_used,
        "notes": extra_notes
    }

    json_path = os.path.join(LOGS_FOLDER, f"{model_name}_log.json")
    with open(json_path, "w") as f:
        json.dump(log_dict, f, indent=4)

    print(f" JSON log saved at: {json_path}")
    return log_dict


def save_log_to_csv(log_dict):
    csv_path = os.path.join(LOGS_FOLDER, "model_logs.csv")
    flat_log = log_dict.copy()

    if os.path.exists(csv_path):
        df = pd.read_csv(csv_path)
        df = pd.concat([df, pd.DataFrame([flat_log])], ignore_index=True)
    else:
        df = pd.DataFrame([flat_log])

    df.to_csv(csv_path, index=False)
    print(f" CSV log updated at: {csv_path}")
