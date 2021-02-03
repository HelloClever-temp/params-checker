def expect_eq(expect, to)
  expect(expect).to(eq(to))
end

def expect_success(cmd)
  expect_eq(cmd.success?, true)
end

def expect_fail(cmd)
  expect_eq(cmd.success?, false)
end

def expect_raise(validator)
  params = {}
  expect { validator.call(params: params) }.to raise_error
end

def expect_raise_message(validator, error_message)
  params = {}
  expect { validator.call(params: params) }.to raise_error(error_message)
end

def expect_not_raise(validator)
  params = {}
  expect { validator.call(params: params) }.not_to raise_error
end
