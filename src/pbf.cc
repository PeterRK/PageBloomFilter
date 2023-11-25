// Copyright (c) 2023, Ruan Kunliang.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

#include <cstring>
#include "pbf.h"
#include "pbf-internal.h"

namespace pbf {

void _PageBloomFilter::init(unsigned page_level, unsigned page_num, size_t unique_cnt, const uint8_t* data) {
	m_page_level = page_level;
	m_page_num = page_num;
	auto space = std::make_unique<uint8_t[]>(data_size());
	if (data == nullptr) {
		m_unique_cnt = 0;
		memset(space.get(), 0, data_size());
	} else {
		m_unique_cnt = unique_cnt;
		memcpy(space.get(), data, data_size());
	}
	m_space = std::move(space);
}

void _PageBloomFilter::clear() noexcept {
	m_unique_cnt = 0;
	if (m_space != nullptr) {
		memset(m_space.get(), 0, data_size());
	}
}

template <unsigned N>
bool PageBloomFilter<N>::test(const uint8_t* data, unsigned len) const noexcept {
	V128X t;
	t.v = Hash(data, len);
	size_t idx = PageHash(t) % m_page_num;
	const uint8_t* page = m_space.get() + (idx << m_page_level);
	return Test<N>(page, m_page_level, t);
}

template <unsigned N>
bool PageBloomFilter<N>::set(const uint8_t* data, unsigned len) noexcept {
	V128X t;
	t.v = Hash(data, len);
	size_t idx = PageHash(t) % m_page_num;
	uint8_t* page = m_space.get() + (idx << m_page_level);
	if (Set<N>(page, m_page_level, t)) {
		m_unique_cnt++;
		return true;
	}
	return false;
}

template class PageBloomFilter<4>;
template class PageBloomFilter<5>;
template class PageBloomFilter<6>;
template class PageBloomFilter<7>;
template class PageBloomFilter<8>;

template <unsigned N>
class BloomFilterImp : public BloomFilter {
public:
	size_t capacity() const noexcept { return self()->capacity(); }
	size_t virual_capacity(float fpr) const noexcept { return self()->virual_capacity(fpr); }
	unsigned way() const noexcept { return self()->way(); }
	bool test(const uint8_t* data, unsigned len) const noexcept { return self()->test(data, len); }
	bool set(const uint8_t* data, unsigned len) noexcept { return self()->set(data, len); }

	explicit BloomFilterImp(PageBloomFilter<N>&& bf) {
		*self() = std::move(bf);
	}

private:
	const PageBloomFilter<N>* self() const noexcept {
		return reinterpret_cast<const PageBloomFilter<N>*>(static_cast<const _PageBloomFilter*>(this));
	}
	PageBloomFilter<N>* self() noexcept {
		return reinterpret_cast<PageBloomFilter<N>*>(static_cast<_PageBloomFilter*>(this));
	}
};

template class BloomFilterImp<4>;
template class BloomFilterImp<5>;
template class BloomFilterImp<6>;
template class BloomFilterImp<7>;
template class BloomFilterImp<8>;

std::unique_ptr<BloomFilter> New(size_t item, float fpr) {
#define PBF_NEW_CASE(w) \
	case w:                												\
	{                   												\
		auto tmp = Create< w >(item, fpr);								\
		if (!tmp) {														\
			return nullptr;												\
		}																\
		return std::make_unique<BloomFilterImp< w >>(std::move(tmp));	\
	}
	switch (BestWay(fpr)) {
		PBF_NEW_CASE(4)
		PBF_NEW_CASE(5)
		PBF_NEW_CASE(6)
		PBF_NEW_CASE(7)
		PBF_NEW_CASE(8)
	}
#undef PBF_NEW_CASE
	return nullptr;
}

std::unique_ptr<BloomFilter> New(unsigned way, unsigned page_level, unsigned page_num,
								 size_t unique_cnt, const uint8_t* data) {
#define PBF_NEW_CASE(w) \
	case w:                													\
	{                   													\
		PageBloomFilter< w > tmp(page_level, page_num, unique_cnt, data);	\
		if (!tmp) {															\
			return nullptr;													\
		}																	\
		return std::make_unique<BloomFilterImp< w >>(std::move(tmp));		\
	}
	switch (way) {
		PBF_NEW_CASE(4)
		PBF_NEW_CASE(5)
		PBF_NEW_CASE(6)
		PBF_NEW_CASE(7)
		PBF_NEW_CASE(8)
	}
#undef PBF_NEW_CASE
	return nullptr;
}

} //pbf

