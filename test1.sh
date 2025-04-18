#!/bin/bash

# Define the main data file
DATA_FILE="supply_list.txt"

# Function to add a new doctor
add_doctor() {
  read -p "Enter doctor's name: " doctor_name
  if grep -q "^$doctor_name:" "$DATA_FILE"; then
    echo "Error: Doctor '$doctor_name' already exists."
    return 1
  fi
  echo "$doctor_name:" >> "$DATA_FILE"
  echo "Doctor '$doctor_name' added."
}

# Function to add/update inventory for a doctor
update_inventory() {
  read -p "Enter doctor's name: " doctor_name
  if ! grep -q "^$doctor_name:" "$DATA_FILE"; then
    echo "Error: Doctor '$doctor_name' not found."
    return 1
  fi

  echo "Enter inventory details for '$doctor_name' (format: Item=Quantity,Item2=Quantity2,...):"
  read inventory_details

  # Update the doctor's line in the data file
  sed -i "s/^$doctor_name:.*$/$doctor_name:$inventory_details/" "$DATA_FILE"
  echo "Inventory for '$doctor_name' updated."
}

# Function to record supply needs for the next visit
record_supply_needs() {
  read -p "Enter doctor's name: " doctor_name
  if ! grep -q "^$doctor_name:" "$DATA_FILE"; then
    echo "Error: Doctor '$doctor_name' not found."
    return 1
  fi

  echo "Enter supply needs for '$doctor_name' (format: Item=Quantity,Item2=Quantity2,...):"
  read supply_needs

  # Append supply needs to the doctor's line (separated by a semicolon)
  sed -i "s/^$doctor_name:\([^;]*\)$/$doctor_name:\1;$supply_needs/" "$DATA_FILE"
  echo "Supply needs for '$doctor_name' recorded."
}

# Function to view the supply list
view_supply_list() {
  if [ -s "$DATA_FILE" ]; then
    echo "--- Supply List ---"
    cat "$DATA_FILE"
    echo "--------------------"
  else
    echo "Supply list is empty."
  fi
}

# Function to view a specific doctor's details
view_doctor_details() {
  read -p "Enter doctor's name: " doctor_name
  if grep -q "^$doctor_name:" "$DATA_FILE"; then
    grep "^$doctor_name:" "$DATA_FILE"
  else
    echo "Error: Doctor '$doctor_name' not found."
  fi
}

# Main menu
while true; do
  echo "\n--- Medical Supply List ---"
  echo "1. Add New Doctor"
  echo "2. Update Doctor's Inventory"
  echo "3. Record Next Visit Supply Needs"
  echo "4. View Supply List"
  echo "5. View Doctor Details"
  echo "6. Exit"
  read -p "Enter your choice: " choice

  case "$choice" in
    1) add_doctor ;;
    2) update_inventory ;;
    3) record_supply_needs ;;
    4) view_supply_list ;;
    5) view_doctor_details ;;
    6) echo "Exiting. Have a productive day!"; break ;;
    *) echo "Invalid choice. Please try again." ;;
  esac
done

How to Use This Script:
 * Save the script: Save the code above as a .sh file (e.g., supply_manager.sh).
 * Make it executable: Open your terminal and run chmod +x supply_manager.sh.
 * Run the script: Execute it with ./supply_manager.sh.
Explanation:
 * DATA_FILE="supply_list.txt": This line defines the file where all the information will be stored.
 * add_doctor():
   * Prompts for the doctor's name.
   * Checks if the doctor already exists in the DATA_FILE.
   * If not, it adds a new line with the doctor's name followed by a colon (which will later hold inventory and supply needs).
 * update_inventory():
   * Prompts for the doctor's name and verifies if they exist.
   * Asks for inventory details in the format Item1=Quantity1,Item2=Quantity2,....
   * Uses sed to find the line for the doctor and replace everything after the colon with the new inventory details.
 * record_supply_needs():
   * Prompts for the doctor's name and verifies if they exist.
   * Asks for the supply needs in the same Item=Quantity format.
   * Uses sed to append the supply needs to the doctor's line, separated by a semicolon from the inventory.
 * view_supply_list():
   * Displays the entire content of the DATA_FILE.
 * view_doctor_details():
   * Prompts for a doctor's name and displays their specific line from the DATA_FILE.
 * while true; do ... done: This creates a continuous loop to display the main menu until the user chooses to exit.
 * case "$choice" in ... esac: This structure handles the user's menu choices and calls the appropriate functions.
Data File Structure (supply_list.txt):
The supply_list.txt file will store data in the following format:
Doctor Name:Item1=Quantity1,Item2=Quantity2,...;ItemA=NeedA,ItemB=NeedB,...
Another Doctor:ItemX=CountX,...;ItemY=OrderY,...

 * The doctor's name is at the beginning of each line.
 * Inventory details (current stock) follow the first colon.
 * Supply needs for the next visit follow a semicolon.
Possible Enhancements:
 * Error Handling: Add more robust error checking (e.g., validating the input format for inventory and supply needs).
 * Data Validation: Ensure that quantities are numbers.
 * Reporting: Create options to generate reports (e.g., a list of all items needed for the next round of supplies).
 * Deleting Doctors: Add a function to remove doctors from the list.
 * More User-Friendly Input: Instead of the comma-separated format, you could prompt for each item and quantity individually.
 * Sorting/Filtering: Implement options to sort the list by doctor's name or filter based on supply needs.
This script provides a basic framework. Feel free to adapt and expand it to better suit the specific needs of your project! Let me know if you have any
