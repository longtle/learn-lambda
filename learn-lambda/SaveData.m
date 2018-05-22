function SaveData(outputName, F, header)
    if (nargin == 3)
        fl = fopen(outputName, 'w+');
        fprintf(fl, strcat(header, '\n'));
        fclose(fl);
    end
    dlmwrite(outputName, F, '-append', 'delimiter', ',');
end %saveData