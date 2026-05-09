class RecommendationData {
  static const Map<String, Map<String, dynamic>> hairAdvice = {
    'Trái Xoan (Oval)': {
      'description':
          'Tỷ lệ cân đối hoàn hảo. Bạn có thể để hầu hết mọi kiểu tóc.',
      'good_hairstyles': [
        'Tóc layer dài uốn nhẹ',
        'Tóc Bob cổ điển',
        'Tóc mái thưa',
      ],
      'bad_hairstyles': ['Tóc mái quá dày làm che khuất các đường nét đẹp.'],
    },
    'Tròn (Round)': {
      'description':
          'Khuôn mặt có chiều dài và rộng gần bằng nhau. Mục tiêu là kéo dài khuôn mặt.',
      'good_hairstyles': [
        'Tóc rẽ ngôi lệch',
        'Tóc Lob (Long Bob) ôm mặt',
        'Pixie vuốt cao',
      ],
      'bad_hairstyles': ['Tóc mái bằng dày', 'Tóc xoăn xù mì che mất cổ.'],
    },
    'Vuông (Square)': {
      'description':
          'Đường xương hàm sắc nét. Bạn nên chọn kiểu tóc làm mềm các góc cạnh.',
      'good_hairstyles': [
        'Tóc uốn sóng lớn',
        'Tóc mái xéo dài',
        'Tóc tỉa layer ôm hàm',
      ],
      'bad_hairstyles': ['Tóc ép thẳng tắp', 'Cắt bằng ngay xương hàm.'],
    },
    'Mặt Dài (Long)': {
      'description':
          'Khuôn mặt thuôn dài. Mục tiêu là tạo chiều ngang để cân đối lại.',
      'good_hairstyles': [
        'Tóc xoăn ngang vai',
        'Tóc mái bằng/mái thưa',
        'Tóc có độ phồng 2 bên',
      ],
      'bad_hairstyles': [
        'Tóc dài ép thẳng (làm mặt dài thêm)',
        'Kiểu tóc vuốt cao quá mức.',
      ],
    },
    'Kim Cương (Diamond)': {
      'description':
          'Gò má rộng, trán và cằm hẹp. Mục tiêu là làm hài hòa vùng gò má.',
      'good_hairstyles': [
        'Tóc mái rèm cửa (Curtain bangs)',
        'Tóc buộc đuôi ngựa thấp',
        'Tóc dài uốn lọn',
      ],
      'bad_hairstyles': ['Tóc Pixie quá ngắn', 'Kiểu tóc vén hết sau tai.'],
    },
    'Không thể xác minh được': {
      'description':
          'Vui lòng chụp chính diện khuôn mặt hoặc không để quá xa máy ảnh.',
      'good_hairstyles': ['Không thể xác minh được'],
      'bad_hairstyles': ['Không thể xác minh được'],
    },
  };
}
