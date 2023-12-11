# FarmEasy

## Overview
FarmEasy is a cutting-edge application aimed at assisting farmers with advanced agricultural insights. It uses machine learning and data analysis to provide ground water level predictions and crop yield recommendations.

## Key Features
- 📲 User Authentication via phone numbers.
- 📍 Location detection and manual entry.
- 💧 Analysis of historical and predicted groundwater levels.
- 🌾 Intelligent crop yield predictions.
- 📅 Seasonal planting guidance.

## Data Collection 📊
FarmEasy utilizes extensive data on underground water levels and soil conditions from various government and private sources, primarily the IWRIS platform. The application covers data from all 29 states and union territories in India. The dataset is preprocessed using Pandas, a Python library, ensuring accurate and up-to-date information for effective water resource management and agricultural planning.

## Model Training 🤖
The core of FarmEasy's predictive analytics is a Linear Regression model, trained using Scikit Learn. It predicts water levels based on year and location, assisting farmers in making informed decisions. The model's output includes graphical representations with years on the X-axis and groundwater values on the Y-axis. 

## Application Usage 🌾
Users can input a location to receive detailed underground water level information. FarmEasy also provides analytics for various crops, including cultivation periods and water requirements, making it a farmer-friendly tool for optimizing agricultural practices.

## Technology Stack
- ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white) for mobile app development.
- ![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white) for database management.
- ![TensorFlow](https://img.shields.io/badge/TensorFlow-FF6F00?style=for-the-badge&logo=tensorflow&logoColor=white) and ![Scikit-Learn](https://img.shields.io/badge/scikit_learn-F7931E?style=for-the-badge&logo=scikit-learn&logoColor=white) for machine learning, including Random Forest.
- ![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge&logo=pandas&logoColor=white) for data analysis.
