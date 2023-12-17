# Material Parameter Calibration

This project is designed to calibrate material parameters using the mathematical description provided by the function Psi. It supports all six states of stress and uses input data from CSV files that describe various types of material loading.

## Description

The calibration process utilizes the stress-strain data for different types of material loading as input. Each row in the CSV file corresponds to a single experiment and includes both strain and stress measurements. The 13th column in the CSV file specifies the type of loading, with the following conventions:
- 1: Uniaxial loading in the x-direction
- 2: Uniaxial tension in the y-direction
- 3: Uniaxial tension in the z-direction
- 4: Pure shear in the xy plane
- 5: Pure shear in the xz plane
- 6: Pure shear in the yz plane

The first six columns are for strain components ($\varepsilon_{11}, \varepsilon_{22}, \varepsilon_{33}, \varepsilon_{12}, \varepsilon_{13},$ and $\varepsilon_{23}$), followed by six columns corresponding to the stress components ($\sigma_{11}, \sigma_{22}, \sigma_{33}, \sigma_{12}, \sigma_{13}, \sigma_{23}$).

After processing, the material parameters are saved in the specified directory under `figures/model_data_folder_name/Parameter File Name`. Corresponding figures and results are also stored in this directory.

## Prerequisites

Before running this project, ensure you have the following:
- MATLAB installed on your computer.
- Basic understanding of material science and stress-strain relationships.

## Installation

To set up the Material Parameter Calibration project, simply clone or download this repository to your local machine.

## Usage

To execute the calibration process, navigate to the project directory and run the main script:

```matlab
git clone https://github.com/Jamal-dev/material_parameters_calibaration/
main.m
```
- Within the GUI:
   - Use the "CSV Load File Path" field to specify the path to your input CSV file.
   - Input the mathematical expression for Psi in the designated text box.
   - Fill in the parameter fields such as ai, batch_size, learning_rate, max_iterations, etc.
   - Specify the model_data.title and model_data.folder_name for the output results.
   - Click "Generate" to start the calibration process.

The results will be saved in the specified directory, and figures will be displayed within the GUI.

Make sure to adjust the `path/to/material-parameter-calibration` to the actual path where you stored the project files.

## Results

Upon successful execution, the calibrated parameters and figures will be saved in the `figures/model_data_folder_name` directory, as specified by the `Parameter File Name` input.

## Contact

If you have any questions or feedback regarding this project, please feel free to reach out to me at jamalahmed68@gmail.com.

## License

This project is open-sourced under the MIT license. See the LICENSE file for details.

