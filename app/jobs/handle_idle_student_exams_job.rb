class HandleIdleStudentExamsJob < ApplicationJob
  def perform(args)
    exam = Exam.find_by_id(args[:exam_id])
    return unless exam.present? && exam.pending_grading?

    exam.student_exams.each do |student_exam|
      next unless student_exam.ongoing?

      student_exam.update_column(:status, :pending_grading)
      AutoGradingJob.set(wait_until: Time.now + 5.minutes).perform_later({ student_exam_id: student_exam.id })
    end
  end
end
