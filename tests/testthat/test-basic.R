test_that("basic", {
    data("rt")
    expect_error(calculate_numbers(rt), NA)
    expect_error(calculate_unity(rt), NA)
    expect_error(calculate_commitment(rt), NA)
})
