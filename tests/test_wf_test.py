#Read output of preprocessing

wftestrunlog = 'wf_testrun/log.txt'


def test_errors():
    errors = []
    warnings = []
    with open(wftestrunlog) as file:
        for line in file:
            if 'ERROR' in line:
                errors.append(line)
                print(line)
            if 'WARNING' in line:
                warnings.append(line)
                print(line)
        assert (len(errors) == 0)