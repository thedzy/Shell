#!/bin/sh

source $(dirname $0)/headline06c.sh

tput reset
printf '\e[3J'

headline "${@:-Lorem ipsum dolor sit amet, consectetur adipiscing elit. In metus nisl, molestie consectetur accumsan eu, efficitur sed nunc. Vivamus cursus ligula ex, vel laoreet eros tincidunt id. Duis sollicitudin dapibus purus vel rhoncus. Nulla facilisi. Etiam consequat metus nibh, ac lacinia dui eleifend a. Curabitur gravida erat justo, et gravida orci auctor id. Donec sit amet erat ut augue volutpat molestie. Fusce tempus auctor mollis. Phasellus imperdiet id elit sed sollicitudin. Fusce at euismod leo, vitae mollis tellus. In quis facilisis massa. Ut a suscipit neque. Suspendisse volutpat porta ligula, eu sollicitudin quam. Praesent at nibh purus. Duis sit amet lorem purus. In convallis, augue ut finibus rutrum, nisi orci efficitur ex, vel feugiat felis purus sit amet nisl. In tempus, leo in vestibulum ultricies, erat turpis ultricies augue, eu varius mi lectus a sapien. Nullam nunc orci, consectetur vitae velit non, pulvinar tempus eros. In porttitor sit amet libero ut feugiat. Donec tincidunt massa ac lobortis eleifend. Nulla nisi orci, molestie vel accumsan at, accumsan vel arcu. Quisque in vestibulum magna, at eleifend nunc. Donec eget metus a elit ultrices gravida at in urna. Vestibulum sed dui vehicula, tempor ipsum vel, congue sapien. Quisque scelerisque ligula leo, non aliquam ante blandit a. Aliquam a cursus arcu, ut fermentum ante. Duis euismod nulla a magna hendrerit, id ultricies odio ornare. Donec imperdiet tellus egestas nibh vulputate, nec sollicitudin turpis consequat. Nulla ullamcorper dolor at magna elementum dictum at eget nibh.}"

exit 0
