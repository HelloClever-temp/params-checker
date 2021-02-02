module Helper
  def expect_eq(expect, to)
    expect(expect).to(eq(to))
  end

  def expect_success(cmd)
    expect_eq(cmd.success?, true)
  end

  def expect_fail(cmd)
    expect_eq(cmd.success?, false)
  end
end