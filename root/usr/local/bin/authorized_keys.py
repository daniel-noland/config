#!/usr/bin/python
import sys

def check_user(userName: str) -> bool:
    print(userName)
    return userName == "dnoland"

def check_fingerprint(fingerprint: str) -> bool:
    print(fingerprint)
    return true

def print_answer() -> str:
    with open("/tmp/sshtest.txt", "w") as f:
        for arg in sys.argv:
            f.write(arg)
            f.write("\n")
    print("ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDDiMUdAG99iWp52AJmUcqfeqPAYbqBL5tTr4k5TEmtZTA4X6YihnYqtwbDkHA++nrWJxtByLdup3APdtK1RfVuuVhWSaXuAquCfVw/BiII0yKQ5zB7kxFt2KL4QFHzr30KlM0rxyEzMGtOXuyEd7USvug1V0zCgZpWBr3sMgv9SvPd3GaI9Y/a/DnMLk1LFnylwudu5Qr/FKb9zn9gSJn5+sNwITA+9RYf7wRGNlMUqVHcnzvcTUe8DyUeUY6l6PyYenanJ49PgcYd5+0zpoFIX3z778nVasuSubBc8CLjeZAQDLAG3W3dD6ZUbczdEaypaiOHtiOb3cJ38f1W4PpmSipBsO6upmjxteV3rxGvHfExQ3XVM6QL/na1loBES+BK98jdWJgUYA3Wd10pfhuKRqqeg3M3xHBIXnBTzBFhYG+ggotbGy2c9LPU9s4y+iE9tGxL092oGTjmiOScMCrecyOY5xjNon3FtyYFsriO/jl6zdzGOhSgFxtHmaD4GtfRD8m6huG9DvCsoWZ3wLw3KkUmh1pzFpVMSZo8fzbm06PYba0wSl8+DSn1NTfSxaT1KgHMy2IQEY2NCQsipin+veXiMUzUBKDFuhfttv2XcwkxvcN5AXw+bCOD424LlaXfSGAZSgk4PYGBNMs1m0lmZkBjbkNAbSwe4GdsVJTq5w== cardno:000604684577")

print_answer()
