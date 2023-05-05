class UpdateExamStatusJob < ApplicationJob

  def perform(args)
    exam = Exam.find_by_id(args[:exam_id])
    return unless exam.present?

    case args[:operation]
    when 'start_exam'
      start_exam(args, exam)
    when 'end_exam'
      end_exam(args, exam)
    end
  end

  private

  def start_exam(args, exam)
    return unless exam.starts_at.round(0) == args[:starts_at].round(0) && exam.valid_status_transition?(exam.status, 'ongoing')
    exam.update!(status: 'ongoing')
  end

  def end_exam(args, exam)
    ends_at = exam.starts_at + exam.duration.minutes
    return unless ends_at.round(0) == args[:ends_at].round(0) && exam.valid_status_transition?(exam.status, 'pending_grading')
    exam.update!(status: 'pending_grading')
  end
end
