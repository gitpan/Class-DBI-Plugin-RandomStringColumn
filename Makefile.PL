use ExtUtils::MakeMaker;
WriteMakefile(
    'NAME'         => 'Class::DBI::Plugin::RandomStringColumn',
    'VERSION_FROM' => 'lib/Class/DBI/Plugin/RandomStringColumn.pm', # finds $VERSION
    'PREREQ_PM'    => {
        Test::More     => 0.32,
        String::Random => 0.20,
        Class::DBI     => 0.95,
    },
);
