#!/usr/bin/env sh

io_reg() {
    # #########
    # Retrieve a class in ioreg
    # :param ioreg_class: (String) Class name
    # :return: (Dict) Classes if more than more found
    # (Object) Class if one found
    # Note: Full classes and objects can be seen with: /usr/sbin/ioreg -bl
    # #########
    export LC_CTYPE=C
    export LANG=C

    CLASS="$1"
    KEY="$2"
    VALUE="$3"

    DATA="$(/usr/sbin/ioreg -bf -c "$CLASS" -r)"

    if [ ! -z "$KEY" ]; then
        DATA="$(echo "$DATA" | grep -Ei "\"$KEY\" =" | sed  "s:.*$KEY.*= \(.*\).*$:\1:g" | tr -d '"')"
    fi

    if [ ! -z "VALUE" ]; then
        DATA="$(echo "$DATA" | grep -Eio "$VALUE")"
    fi

    echo "$DATA"
}

print_values(){
    # #########
    # Print key and/or value nicely formated
    # :param key: Key(s)
    # :param value: Value
    # #########

      export LC_CTYPE=C
    export LANG=C

    KEYS="$1"
    VALUES="$2"

    printf "%-20s %s" "$KEYS" "$VALUES" | sed "s:^:    :g"

}

print_values

# #########
# Volumes
# #########
printf 'Volumes:\n'
print_values "$(io_reg AppleAPFSVolume "BSD Name")"

# #########
# Machine Information
# #########
printf 'Machine Info:\n'
print_values 'Serial Number' "$(io_reg IOPlatformExpertDevice "IOPlatformSerialNumber")"
print_values 'UUID' "$(io_reg IOPlatformExpertDevice "IOPlatformUUID")"
print_values 'Product Name' "$(io_reg IOPlatformExpertDevice "model")"


# #########
# Video Cards
# #########
printf 'Video Cards:\n'
print_values "$(io_reg IOPCIDevice "model")"
print_values "Active GPU" "$(io_reg AppleMuxControl "ActiveGPU")"

# #########
# BlueTooth
# #########
printf 'BlueTooth\n'
print_values 'Address' "$(io_reg IOBluetoothHCIController "BluetoothDeviceAddress")"
print_values 'Name' "$(io_reg IOBluetoothHCIController "BluetoothLocalName")"
print_values 'Wake Enabled' "$(io_reg IOBluetoothHCIController "RemoteWakeEnabled")"
print_values 'Built-in' "$(io_reg IOBluetoothHCIController "Built-In")"
print_values 'Vendor' "$(io_reg IOBluetoothHCIController "BluetoothVendor")"

printf 'BlueTooth Devices:\n'
print_values "$(io_reg IOBluetoothHCIController "([0-9a-f]{2}-){5}[0-9a-f]{2}" "Product=.*?,")"

# #########
# USB Devices
# #########
printf 'USB Devices:\n'
print_values "$(io_reg IOUSBHostDevice "USB Product Name")"

# #########
# Battery Information
# #########
printf 'Battery Info:\n'
print_values 'Current Capacity' "$(io_reg AppleSmartBattery "CurrentCapacity")"
print_values 'Design Capacity' "$(io_reg AppleSmartBattery "DesignCapacity")"
print_values 'Cycle Count' "$(io_reg AppleSmartBattery "CycleCount")"
print_values 'Design Cycle Count' "$(io_reg AppleSmartBattery "DesignCycleCount9C")"
print_values 'Manufacturer' "$(io_reg AppleSmartBattery "Manufacturer")"


exit
