while (<STDIN>) {
   my $infilename = $_;

   $_ =~ m/([^.]+)/;
   my $outfilename = $1.'.tex';

   open INFILE, '<'.$infilename;
   open OUTFILE, '>new\\'.$outfilename;

   my $token = '\[';

   while (<INFILE>) {
     my $line = $_;
     #-------������---------
     
     #���������� ����� ����������� ������
     while ($line =~ s/\$\$/$token/) {
       if ($token eq '\[') {$token = '\]'}
       else {$token = '\['};
     }
     $line =~ s/\\\[ +/\\\[/g;
     $line =~ s/ +\\\]/\\\]/g;

     #���������� ����� �������������� ������
     $line =~ s/\\\(/\$/g;
     $line =~ s/\\\)/\$/g;
     
     #������������� �������
     $line =~ s/ +/ /g;
     
     #������� � ������ ������
     $line =~ s/ $//g;
     
     #������� ����
     $line =~ s/ --- /~--- /g;

     #������
     $line =~ s/ \\(ref|pageref)\{/~\\$1\{/g;

     #����- � ������������� ����� (������ ��� ������ ������)
     $line =~ s/([ ~(][�-��-�][�-�]?) /$1~/g;
     $line =~ s/([ ~(][�-��-�][�-�]?) /$1~/g;

     #���������� ���� �. �., �. �., � �. �., ��������.
     $line =~ s/([ ~(].)\. (.)\./$1\.~$2\./g;

     #�������� �������
     $line =~ s/([�-�]) (\$[^\$]{1,10}\$)/$1~$2/g;
     
     print OUTFILE "$line";
     
     #-------����� ��������----------
     #������������� ������������� �����
     undef $word;
     while ($line =~ m/([^ ]+)/g) {
       if (($word eq $1) && ($word =~ m/^[�-��-�]+/g)) {
         print "====������������� ����� � ����� $outfilename?: $word====\n";
         print $line;
         print "\n\n";
       }
       $word = $1;
     }

     #������� ��� ������ ������
     while ($line =~ m/(([.,;:)][�-��-�])|([�-��-�] [.,;:)]))/g) {
         print "====������� ��� ������ ������ � ����� $outfilename?: $1====\n";
         print $line;
         print "\n\n";
     }

     #������ ������ ������ ������
     while ($line =~ m/\$([^\$]+)\$/g) {
         my $formula = $1;
         
         undef $balance;
         while ($balance >= 0 && $formula =~ m/(\(|\))/g) {
            if ($1 eq '(') {$balance = $balance + 1}
            else {$balance = $balance - 1}
         }
         
         if (!($balance == 0)) {
            print "����: $outfilename, �������: $formula, ������ ������: $balance.\n\n"
         }
     }
     #�������������� ������������� ���������
    #### \\(exists|forall) +([A-Z\(]|\\neg)

   }
   close(INFILE);
   close(OUTFILE);
}
