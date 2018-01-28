person_base = [747, 799, 1];
person_head = [747, 219, 1];
christ_base = [427, 680, 1];
christ_head = [427, 421, 1];

%img = imread ('../input/Painting.jpg');
%imshow(img)
%[X, Y, BUTTONS] = ginput ()

%person_head = [X(1), Y(1), 1]
%person_base = [X(1), Y(2), 1]
%christ_head = [X(3), Y(3), 1]
%christ_base = [X(3), Y(4), 1]
%horizon = [0, 1, -1*Y(5)]

horizon = [0, 1, -583];

vanishing_point = cross( cross(person_base, christ_base), horizon); % in the direction of line passing from person_base to christ_base

line_christ_head = cross(vanishing_point, christ_head);

line_person = cross(person_base, person_head);

t = cross(line_christ_head, line_person); % intersection point of line_chead and line_person

t = t ./ t(3); % homogeneous to cartsaian coordinate
% Note : in calculation of euclidean norm, third homogeneous coordinate will be 1
%        for all points thus last coordinate is NOT dropped

christ_real_height = 180;

person_real_height = christ_real_height * (norm(person_head-person_base, 2) / norm(t-person_base, 2))
