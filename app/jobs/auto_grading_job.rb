class AutoGradingJob < ApplicationJob
  def perform(args)
    student_exam = StudentExam.find_by_id(args[:student_exam_id])
    return unless student_exam.present?

    grade_each_question(student_exam)
    student_exam.calculate_grade_and_transition
  end

  private

  def grade_each_question(student_exam)
    student_exam.student_answers.map do |student_answer|
      question = student_answer.exam_question.question
      next unless question.mcq? || question.true_or_false?

      correct_answers = question.correct_answers
      probability = (1.0 / correct_answers.size)
      correctly_answered_choices = correct_answers.where(answer: student_answer.answer)

      full_mark = student_answer.exam_question.score
      score = probability * correctly_answered_choices.size * full_mark

      student_answer.update!(score: score, auto_grading: true)
    end
  end
end
