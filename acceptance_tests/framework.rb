module MT
  def self.assert(desc, left, operator, right = nil) = puts (if msgs = self.send(operator, desc, left, right) then failure(msgs) else success(desc) end)
  def self.test(desc, &block) ; puts desc ; yield ; puts "\n" end
  def self.success(msg) = "  \e[32m#{msg}\e[0m"
  def self.failure(msgs) = "  \e[31m#{msgs.join("\n    ")}\e[0m"
end

module MT
  # positive assertions
  def self.equals(desc, left, right) = (["#{desc} failed.", "Expected: #{right}", "Received: #{left}"] unless left == right)
  def self.contains(desc, left, right) = (["#{desc} failed.", "Expected: #{left} to contain #{right}", "Received: #{left}"] unless left.include?(right))
  def self.is_a(desc, left, right) = (["#{desc} failed.", "Expected: #{left} is a #{right}", "Received: #{left.class}"] unless left.is_a?(right))
  def self.is_truthy(desc, left, _right) = (["#{desc} failed.", "Expected: #{left} to be truthy", "Received: #{left.class}"] unless left)
  def self.is_nil(desc, left, _right) = (["#{desc} failed.", "Expected: #{left} to be nil", "Received: #{left.class}"] unless left.nil?)
  def self.matches(desc, left, right) = (["#{desc} failed.", "Expected: #{left} to match #{right}"] unless left.match? right)

  # negative assertions
  def self.doesnt_equal(desc, left, right) = (["#{desc} failed.", "Expected: #{left} and #{right} not to be the same"] if equals(desc, left, right))
  def self.doesnt_contain(desc, left, right) = (["#{desc} failed.", "Expected: #{left} not to contain #{right}"] if contains(desc, left, right))
  def self.is_falsey(desc, left, _right) = (["#{desc} failed.", "Expected: #{left} to be falsey", "Received: #{left.class}"] if left)
end

module MT
end
