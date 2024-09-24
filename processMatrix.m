function [out1, out2] = processMatrix(tr, mat)
    % Check for square matrix
    if ~(numel(mat(1,:)) == numel(mat(:,1)))
        error("The number of elements in rows and columns is not equal.");
    end

    % Check for zero diagonal elements
    for i = 1:numel(mat(1,:))
        if ~(mat(i,i) == 0)
            error('The element of input(%d,%d) is not 0', i, i);
        end
    end

    % Extract usable data from the matrix
    usable_data = zeros(numel(mat(1,:)) * (numel(mat(1,:)) - 1), 1);
    udc = 1;
    for i = 1:numel(mat(1,:))
        for j = 1:numel(mat(1,:))
            if i ~= j
                usable_data(udc) = mat(i,j);
                udc = udc + 1;
            end
        end
    end

    % Normalize the usable data
    norm = (usable_data - min(usable_data)) / (max(usable_data) - min(usable_data));

    % Threshold calculations
    zeros_data = norm((0 <= norm) & (norm <= 0.15));
    ones_data = norm((0.85 <= norm) & (norm <= 1));
    potential_0 = sort(norm((0.15 < norm) & (norm <= 0.3)));
    potential_1 = sort(norm((0.7 <= norm) & (norm < 0.85)));
    
    % Counts
    i1 = numel(ones_data);
    i0 = numel(zeros_data);
    p1 = numel(potential_1);
    p0 = numel(potential_0);
    
    % Calculate first threshold
    ftr = i1 / (numel(mat(:,1)) * (numel(mat(:,1)) - 1));
    
    % Decision making for thresholds
    if tr > ftr
        need1 = round((tr - ftr) * numel(mat(1,:)) * (numel(mat(1,:)) - 1));
        if need1 > p1
            error("It's impossible to reach this threshold.");
        else
            for i = 1:need1
                norm(find(norm == potential_1(i), 1)) = 0.85;
            end
        end
    else
        need0 = round((ftr - tr) * numel(mat) * (numel(mat) - 1));
        if need0 > p0
            error("It's impossible to reach this threshold.");
        else
            for i = 1:need0
                norm(find(norm == potential_0(i), 1)) = 0.15;
            end
        end
    end
    
    % Denormalize and create output matrices
    oc = 1;
    denorm = ((max(usable_data) - min(usable_data)) * norm) + min(usable_data);
    out1 = mat;
    out2 = mat; % Create output matrix for denormalized values
    
    for i = 1:numel(mat(1,:))
        for j = 1:numel(mat(1,:))
            if i ~= j
                out1(i,j) = norm(oc);
                out2(i,j) = denorm(oc);
                oc = oc + 1;
            end
        end
    end
end
