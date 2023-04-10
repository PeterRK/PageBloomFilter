// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#pragma once
#ifndef PAGE_BLOOM_FILTER_H
#define PAGE_BLOOM_FILTER_H

#include <cstdint>
#include <cstddef>
#include <memory>
#include <type_traits>

namespace pbf {

//Lemire-Kaser-Kurz
template <typename Word>
class Divisor {
private:
	static_assert(std::is_same<Word, uint8_t>::value || std::is_same<Word, uint16_t>::value
				  || std::is_same<Word, uint32_t>::value, "");
	Word m_val = 0;
#ifndef DISABLE_SOFT_DIVIDE
	static constexpr unsigned BITWIDTH = sizeof(Word)*8;
	using DoubleWord = typename std::conditional<std::is_same<Word,uint8_t>::value, uint16_t,
			typename std::conditional<std::is_same<Word,uint16_t>::value, uint32_t, uint64_t>::type>::type;
	using QuaterWord = typename std::conditional<std::is_same<Word,uint8_t>::value, uint32_t,
			typename std::conditional<std::is_same<Word,uint16_t>::value, uint64_t, __uint128_t>::type>::type;
	DoubleWord m_fac = 0;
#endif

public:
	Word value() const noexcept { return m_val; }
	Divisor() noexcept = default;
	explicit Divisor(Word n) noexcept { *this = n; }

	Divisor& operator=(Word n) noexcept {
		m_val = n;
#ifndef DISABLE_SOFT_DIVIDE
		if (n == 0) {
			m_fac = 0;
		} else {
			constexpr DoubleWord zero = 0;
			m_fac = (DoubleWord)~zero / n + 1;
		}
#endif
		return *this;
	}

	Word div(Word m) const noexcept {
#ifdef DISABLE_SOFT_DIVIDE
		return m / m_val;
#else
		Word q = (m * (QuaterWord)m_fac) >> (BITWIDTH * 2);
		if (m_fac == 0) {
			q = m;
		}
		return q;
#endif
	}

	Word mod(Word m) const noexcept {
#ifdef DISABLE_SOFT_DIVIDE
		return m % m_val;
#else
		return ((QuaterWord)m_val * (DoubleWord)(m * m_fac)) >> (BITWIDTH * 2);
#endif
	}
};

template <typename Word>
static inline Word operator/(Word m, const Divisor<Word>& d) noexcept {
	return d.div(m);
}

template <typename Word>
static inline Word operator%(Word m, const Divisor<Word>& d) noexcept {
	return d.mod(m);
}


class _PageBloomFilter {
public:
	bool operator!() const noexcept { return m_space == nullptr; }
	unsigned page_level() const noexcept { return m_page_level; }
	unsigned page_num() const noexcept { return m_page_num.value(); }
	size_t unique_cnt() const noexcept { return m_unique_cnt; }
	const uint8_t* data() const noexcept { return m_space.get(); }
	size_t data_size() const noexcept {
		return static_cast<size_t>(m_page_num.value()) << m_page_level;
	}
	void clear() noexcept;

protected:
	unsigned m_page_level = 0;
	Divisor<uint32_t> m_page_num;
	size_t m_unique_cnt = 0;
	std::unique_ptr<uint8_t[]> m_space;

	void init(unsigned page_level, unsigned page_num, size_t unique_cnt, const uint8_t* data);
};

template <unsigned N>
class PageBloomFilter final : public _PageBloomFilter {
public:
	static_assert(N >= 4 && N <= 8, "N should be 4-8");

	// page_level should be (8-8/N) ~ 13
	PageBloomFilter(unsigned page_level, unsigned page_num, size_t unique_cnt=0, const uint8_t* data=nullptr) {
		if (page_level < (8-8/N) || page_level > 13) {
			return;
		}
		init(page_level, page_num, unique_cnt, data);
	}

	// unique_cnt/capacity should be 50%-80%
	size_t capacity() const noexcept {
		return data_size() * 8 / N;
	}

	bool test(const uint8_t* data, unsigned len) const noexcept;
	bool set(const uint8_t* data, unsigned len) noexcept;
};

extern template class PageBloomFilter<4>;
extern template class PageBloomFilter<5>;
extern template class PageBloomFilter<6>;
extern template class PageBloomFilter<7>;
extern template class PageBloomFilter<8>;

} //pbf
#endif //PAGE_BLOOM_FILTER_H
