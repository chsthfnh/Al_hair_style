class RecommendationData {
  static const Map<String, Map<String, dynamic>> hairAdvice = {
    'Oval': {
      'description':
          'Khuôn mặt Oval có tỷ lệ cân đối, đường nét hài hòa và dễ phù hợp với nhiều kiểu tóc khác nhau cho cả nam và nữ.',

      'good_hairstyles': {
        'Nam': [
          'Undercut vuốt textured',
          'Side Part cổ điển',
          'Layer Hàn Quốc',
          'Quiff tự nhiên',
        ],

        'Nữ': [
          'Tóc layer dài uốn nhẹ',
          'Tóc bob ngang vai',
          'Tóc mái bay Hàn Quốc',
          'Tóc xoăn sóng lơi',
        ],
      },

      'bad_hairstyles': {
        'Nam': ['Tóc ép sát đầu', 'Mái quá dày che kín trán'],

        'Nữ': ['Tóc quá ôm sát mặt', 'Mái quá dày che toàn bộ khuôn mặt'],
      },
    },

    'Round': {
      'description':
          'Khuôn mặt tròn có chiều dài và chiều rộng gần bằng nhau. Nên chọn kiểu tóc tạo cảm giác mặt thon và dài hơn.',

      'good_hairstyles': {
        'Nam': [
          'Undercut cao',
          'Mohican ngắn',
          'Side Part 7/3',
          'Textured Crop dựng nhẹ',
        ],

        'Nữ': [
          'Tóc layer ôm mặt',
          'Tóc lob ngang vai',
          'Tóc dài uốn sóng',
          'Mái bay hoặc mái thưa',
        ],
      },

      'bad_hairstyles': {
        'Nam': ['Tóc úp sát đầu', 'Mái bằng dày'],

        'Nữ': ['Tóc xoăn phồng ngang mặt', 'Tóc ôm sát hai bên má'],
      },
    },

    'Square': {
      'description':
          'Khuôn mặt vuông có xương hàm rõ và góc cạnh mạnh. Kiểu tóc phù hợp nên giúp gương mặt mềm mại và cân đối hơn.',

      'good_hairstyles': {
        'Nam': [
          'Layer rũ tự nhiên',
          'Side Part mềm',
          'Tóc medium wavy',
          'Undercut thấp',
        ],

        'Nữ': [
          'Tóc uốn sóng lớn',
          'Tóc layer ôm hàm',
          'Tóc ngang vai uốn cụp',
          'Mái xéo dài',
        ],
      },

      'bad_hairstyles': {
        'Nam': ['Tóc quá ngắn sát đầu', 'Vuốt dựng quá cứng'],

        'Nữ': ['Tóc ép thẳng sát mặt', 'Cắt ngang đúng xương hàm'],
      },
    },

    'Oblong': {
      'description':
          'Khuôn mặt dài (Oblong) có chiều dài nổi bật hơn chiều rộng. Nên chọn kiểu tóc giúp tạo độ cân đối theo chiều ngang.',

      'good_hairstyles': {
        'Nam': [
          'Layer phủ nhẹ trán',
          'Textured Crop',
          'Side Part thấp',
          'Tóc uốn nhẹ tự nhiên',
        ],

        'Nữ': [
          'Tóc ngang vai uốn nhẹ',
          'Tóc xoăn sóng ngang',
          'Mái thưa hoặc mái bằng',
          'Tóc có độ phồng hai bên',
        ],
      },

      'bad_hairstyles': {
        'Nam': ['Vuốt dựng quá cao', 'Fade cao sát đầu', 'Tóc quá ôm sát mặt'],

        'Nữ': [
          'Tóc quá dài và thẳng',
          'Tóc ép sát không có độ phồng',
          'Buộc cao làm lộ chiều dài khuôn mặt',
        ],
      },
    },

    'Heart': {
      'description':
          'Khuôn mặt trái tim có phần trán rộng và cằm nhỏ. Nên chọn kiểu tóc giúp cân bằng phần trên và tạo độ đầy ở phần dưới khuôn mặt.',

      'good_hairstyles': {
        'Nam': [
          'Layer medium',
          'Side swept',
          'Textured Fringe',
          'Tóc rũ tự nhiên',
        ],

        'Nữ': [
          'Tóc mái rèm cửa',
          'Tóc dài uốn lọn',
          'Tóc bob uốn nhẹ',
          'Tóc ngang vai layer',
        ],
      },

      'bad_hairstyles': {
        'Nam': ['Vuốt quá cao', 'Undercut quá sát'],

        'Nữ': ['Pixie cực ngắn', 'Vén hết tóc ra sau'],
      },
    },

    'Không thể xác minh được': {
      'description':
          'AI chưa thể nhận diện chính xác khuôn mặt. Hãy chụp chính diện, đủ sáng và không che khuôn mặt.',

      'good_hairstyles': {
        'Nam': ['Vui lòng thử lại với ảnh rõ hơn'],

        'Nữ': ['Vui lòng thử lại với ảnh rõ hơn'],
      },

      'bad_hairstyles': {
        'Nam': ['Ảnh quá tối'],

        'Nữ': ['Che mặt hoặc nghiêng quá nhiều'],
      },
    },
  };
}
