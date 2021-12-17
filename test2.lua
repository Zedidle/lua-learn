local TEST_A = {
    [1] = 100,
    [2] = 200
}
print("TEST_A:", TEST_A[1], TEST_A[2])

function Try_ChangeA()
    local A = TEST_A
    A[1] = 10
    A[2] = 20
    print("A：", A[1], A[2])
end
Try_ChangeA()
print("TEST_A:", TEST_A[1], TEST_A[2])
