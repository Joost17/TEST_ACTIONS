#Read output of preprocessing

wftestrunlog = 'wf_testrun/log.txt'


def test_errors():
    with open(wftestrunlog) as file:
        for line in file:
            print(line)
            assert (not('ERROR' in line))