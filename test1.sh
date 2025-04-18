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

