# Electricity Consumption Tracker 🌍⚡

This repository contains the semester project for the Mobile Applications Development course, developed using **Flutter**. The project focuses on building an intuitive and user-friendly mobile application to monitor and analyze **electricity consumption** in real time.

### Features
- 📊 **Real-time electricity consumption tracking**: Continuously retrieves and displays up-to-date consumption data.
- 📈 **Interactive trend analysis**: Visual representation of usage trends through dynamic and responsive charts.
- 🔔 **Customizable notifications**: Alerts for exceeding predefined consumption limits.
- 🌱 **Sustainability insights**: Provides personalized tips for optimizing electricity usage and promoting energy efficiency.
- 🌐 **Multi-language support**: Enhanced accessibility for users across different regions.
- 🔄 **Offline data caching**: Ensures that critical consumption data remains accessible even without an active internet connection.
- ☁️ **Cloud synchronization**: Optionally syncs local data with Cloud Firestore to allow cross-device access and backup.

### Goals
- Increase user awareness of personal energy consumption patterns.
- Deliver actionable insights to help reduce energy costs and environmental impact.
- Provide a smooth, responsive, and cross-platform mobile experience (iOS & Android).
- Facilitate further research on energy consumption analytics through modular and extensible design.

### Technologies Used
- **Flutter**: A modern, cross-platform mobile development framework.
- **Dart**: The programming language used for developing the application.
- **Cloud Firestore / SQLite**: For flexible data storage and synchronization (Cloud Firestore is used for remote storage, while SQLite is employed locally).
- **Chart Libraries (e.g., fl_chart, syncfusion_flutter_charts)**: For interactive and engaging data visualization.
- **Localization Packages**: To support multi-language capabilities and ensure broader accessibility.

### How to Use
1. **Clone the Repository**  
   Clone the project using Git:
   ```bash
   git clone https://github.com/JakubStepanek/pma-js-electricity-consumption.git
   ```

2. **Install Dependencies**  
   Navigate to the project directory and install all dependencies:
   ```bash
   flutter pub get
   ```
   This command downloads and installs all required packages as specified in *pubspec.yaml*.

3. **Run the Application**  
   To run the app on an emulator or connected device, execute:
   ```bash
   flutter run
   ```
   Alternatively, open the project in an IDE (such as Android Studio or VS Code with Flutter support) and launch the app using the IDE’s run configuration.

### Project Structure
- **/lib**: Contains the main source code. The code is modularized into components for data fetching, processing, and visualization.
- **/assets**: Holds static resources such as images, icons, and localized language files.
- **/test**: Includes unit and integration tests ensuring the robustness of key functionalities.
- **pubspec.yaml**: Configuration file defining dependencies, assets, and project metadata.
- **/docs**: Additional documentation including architectural diagrams, API descriptions, and module-level explanations.

### About the Developer
This project was developed as part of a semester-long assignment at the **Technical University of Liberec** for the **Mobile Applications Development** course. The application is designed with both practical utility and academic rigor in mind, serving as a demonstrative example of modern cross-platform mobile development and energy analytics.

### Contributing
Contributions are welcome! If you wish to enhance the project or fix issues:
- Please adhere to the established coding standards and document your changes.
- Ensure that all modifications are accompanied by appropriate tests.
- Submit pull requests to the `develop` branch for review.

### License
This project is licensed under the [MIT License](LICENSE). Please refer to the LICENSE file for detailed licensing terms.

---

*Electricity Consumption Tracker* is a robust tool designed to help users better understand and manage their energy usage. Its modular architecture, combined with real-time data processing and cloud synchronization, makes it both a practical solution for end users and a solid foundation for further academic exploration in the field of energy consumption analytics.

